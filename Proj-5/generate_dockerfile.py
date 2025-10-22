import ollama

# this is the prompt for the LLM model
PROMPT = """
ONLY Generate an ideal Dockerfile for {language} with best practices. Do not provide any description
Include:
- Base image
- Installing dependencies
- Setting working directory
- Adding source code
- Running the application
"""

# provide the prompt with desired language and store the response from the LLM

def generate_dockerfile(language):
    response = ollama.chat(model='llama3.1:8b', messages=[{'role': 'user' , 'content': PROMPT.format(language=language)}])
    return response['message']['content']

if __name__ == '__main__':
    language = input("Enter the programming language:")
    dockerfile = generate_dockerfile(language)
    print("\nGenerating the Dockerfile:\n")
    print(dockerfile)
