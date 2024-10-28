"""
Create the skeleton of a new project in the current directory given the project
name.
"""
import argparse
import os

def create_project(project_name):
    """
    Create the skeleton of a new project in the current directory given the
    project name.
    """
    os.makedirs(project_name, exist_ok=True)

    for subdir in [
        "cli", "configs", "data_pipeline", "data", "demo", "figs", "logs",
        "models", "nbs", "viz", "tests", "utils", project_name
    ]:
        os.makedirs(os.path.join(project_name, subdir), exist_ok=True)

    # add a .gitignore file to auto-ignore data, logs, models, nbs folders
    with open(os.path.join(project_name, ".gitignore"), "w") as f:
        f.write("data\nlogs\nmodels\nnbs\n")

    # add a README.md file
    with open(os.path.join(project_name, "README.md"), "w") as f:
        f.write(f"# {project_name}\n\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("project_name", help="Name of the project to create")
    args = parser.parse_args()
    create_project(args.project_name)
    print(f"Created project {args.project_name}")
