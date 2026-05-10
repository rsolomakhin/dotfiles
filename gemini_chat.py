import os
import sys
from google import genai

def main():
    # Check for GEMINI_API_KEY
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("Error: GEMINI_API_KEY environment variable is not set.")
        sys.exit(1)

    # Initialize client
    try:
        client = genai.Client()
    except Exception as e:
        print(f"Error initializing client: {e}")
        sys.exit(1)

    model_id = "gemini-3-flash-preview"
    previous_interaction_id = None

    # Initialize system instruction
    system_instruction = ""

    # Load Project Overview (README.md)
    if os.path.exists("README.md"):
        try:
            with open("README.md", "r") as f:
                system_instruction += "# Project Overview\n\n" + f.read() + "\n\n"
        except Exception as e:
            print(f"Warning: Could not read README.md: {e}")

    # Load Legal & Terms (TERMS.md)
    if os.path.exists("TERMS.md"):
        try:
            with open("TERMS.md", "r") as f:
                system_instruction += "# Legal & Terms\n\n" + f.read() + "\n\n"
        except Exception as e:
            print(f"Warning: Could not read TERMS.md: {e}")

    # Load core standards from AGENTS.md (Mandatory)
    agents_file = "AGENTS.md"
    if not os.path.exists(agents_file):
        print(f"Error: {agents_file} not found in the current directory.")
        sys.exit(1)
    
    try:
        with open(agents_file, "r") as f:
            system_instruction += "# Core Standards\n\n" + f.read()
    except Exception as e:
        print(f"Error reading {agents_file}: {e}")
        sys.exit(1)

    # Load all skills from skills/*/SKILL.md
    import glob
    skill_files = glob.glob("skills/*/SKILL.md")
    if skill_files:
        system_instruction += "\n\n# Available Skills\n"
        for skill_path in skill_files:
            try:
                skill_name = os.path.basename(os.path.dirname(skill_path))
                with open(skill_path, "r") as f:
                    system_instruction += f"\n## Skill: {skill_name}\n\n" + f.read() + "\n"
            except Exception as e:
                print(f"Warning: Could not read skill at {skill_path}: {e}")

    print(f"Chatting with {model_id}.")
    print(f"Loaded core standards from {agents_file} and {len(skill_files)} skills.")
    print("Type '/exit' or '/quit' to stop.")

    while True:
        try:
            # Get user input
            user_input = input("You: ").strip()
            
            # Handle exit commands
            if user_input.lower() in ["/exit", "/quit"]:
                print("Goodbye!")
                break
            
            if not user_input:
                continue

            # Create interaction
            interaction = client.interactions.create(
                model=model_id,
                input=user_input,
                system_instruction=system_instruction,
                previous_interaction_id=previous_interaction_id
            )

            # Update state
            previous_interaction_id = interaction.id

            # Print model output (using new steps schema)
            # Find the last model_output step
            output_text = ""
            for step in reversed(interaction.steps):
                if step.type == "model_output":
                    for part in step.content:
                        if part.type == "text":
                            output_text = part.text
                            break
                    if output_text:
                        break
            
            if output_text:
                print(f"Gemini: {output_text}")
            else:
                print("Gemini: [No text output received]")

        except (EOFError, KeyboardInterrupt):
            print("\nGoodbye!")
            break
        except Exception as e:
            print(f"\nError during interaction: {e}")

if __name__ == "__main__":
    main()
