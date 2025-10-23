import subprocess

PROMPT = """
ONLY Generate an ideal Dockerfile for {language} with best practices. Do not provide any description.
Include:
- Base image
- Installing dependencies
- Setting working directory
- Adding source code
- Running the application
"""

def generate_dockerfile(language):
    prompt = PROMPT.format(language=language)
    command = f'ollama run llama3.2:1b "{prompt}"'
    
    # Run the command and capture the output
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    return result.stdout.strip()

if __name__ == '__main__':
    language = input("Enter the programming language: ")
    dockerfile = generate_dockerfile(language)
    print("\nGenerated Dockerfile:\n")
    print(dockerfile)

