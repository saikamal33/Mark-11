# Research the Kubernetes blog and to write a blog(MD file) to summarize top 10 trends

## Difference between AI agents and AI Assistant

**AI Assistant** : The Primary purpose of AI assitant is to help us in a coversational style approach. They are task focused and can not execute them independently

EX: cheatGPT, Gemini

**AI Agent** : They can perform tasks on our behalf as they can work independently.

EX: github Copilat

**AI Agent Framework** : The frameworks are used to generate our own AI Agents. Some examples of AI agent frameworks are:

1) Autogen	2) Lang graph	3)Crew AI

Now we can create the project.
## Prerequsites:
- Python >=3.10 to 3.13
- llama3.1:latest
  
## Installation Process
- Create a virtual env for the pyhton project

		python3 -m venv crew
- install the crew agent using pip

		pip install crewai
- Now we create a crew ai python package

		crewai create crew ai-devops-proj

## Use case

No coding and development is required here as crew ai is ment to be used for research purpose all the prompts for the agents are configured in a way of getting optimal research output.

- We need to update the **topics** in the main.py python file

		vi ai_devops_proj/src/ai_devops_proj/main.py

- now we need to run the below commands

		crewai install
  		crewai run
  
  
