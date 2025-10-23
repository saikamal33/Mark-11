# we will be using googles gen ai api key so we are importing this module

import google.generativeai as genai
import os

# we will set the api key as env variable
os.environ["GOOGLE_API_KEY"] = "XXXXXXXXXXXXXX"

#genaai model config
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))
model = genai.GenerativeModel('gemini-1.5-pro')

PROMPT = """
ONLY Generate an ideal Dockerfile for {language} with best practices. Do not provide any description
Include:
- Base image
- Installing dependencies
- Setting working directory
- Adding source code
- Running the application
"""

def generate_dockerfile(language):
    response = model.generate_content(PROMPT.format(language=language))
    return response.text

if __name__ == '__main__' :
    language = input("enter the programming language: ")
    dockerfile = generate_dockerfile(language)
    print("\nGenerating Dockerfile:\n")
    print(dockerfile)
