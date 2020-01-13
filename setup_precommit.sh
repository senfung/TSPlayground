#!/usr/bin/env bash

echo "==========Dependencies Installation=========="
pip3 install pre-commit

echo "==========Setting Up Pre-commt Hooks=========="
if [ ! -f .pre-commit-config.yaml ]; then
    echo "repos:" >> .pre-commit-config.yaml
else
    echo "File .pre-commit-config.yaml exists."
fi

if ls ./*.py 1> /dev/null 2>&1; then
    echo "Python files detected. Installing pylint..."
    pip3 install pylint

    echo "==========Checking Pylint Configuration File=========="
    if [ ! -f pylintrc ]; then
        python3 -m pylint --generate-rcfile > pylintrc
        echo "File pylintrc has been created."
    else
        echo "File pylintrc exists."
    fi

    if grep -q mirrors-pylint ".pre-commit-config.yaml"; then
        echo "Pylint exists in hook."
    else
        echo "Adding Pylint to hook."
        echo "-   repo: https://github.com/pre-commit/mirrors-pylint" >> .pre-commit-config.yaml
        echo "    rev: v2.4.3" >> .pre-commit-config.yaml
        echo "    hooks:" >> .pre-commit-config.yaml
        echo "    -   id: pylint" >> .pre-commit-config.yaml
        echo "        name: pylint" >> .pre-commit-config.yaml
        echo "        entry: python3 -m pylint" >> .pre-commit-config.yaml
        echo "        language: system" >> .pre-commit-config.yaml
        echo "        types: [python]" >> .pre-commit-config.yaml
        echo "File .pre-commit-config.yaml has been created."
    fi
fi

if ls ./*.go 1> /dev/null 2>&1; then
    echo "Go files detected. Installing golint..."
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     machine=Linux;;
        Darwin*)    machine=Mac;;
        *)          machine="UNKNOWN:${unameOut}"
    esac
    echo ${machine}
    if [ "$machine" = "Linux" ]; then
        echo "Installing golint on Linux..."
        sudo apt install golint
    elif [ "$machine" = "Mac" ]; then
        echo "Installing golint on Mac..."
	GO111MODULE=off go get -u golang.org/x/lint/golint
	sudo cp $(go env GOPATH)/bin/golint $(go env GOROOT)/bin/
    fi
    if grep -q pre-commit-golang ".pre-commit-config.yaml"; then
        echo "Golang tools exist in hook."
    else
        echo "Adding Golang tools to hook."
        echo "-   repo: git://github.com/Bahjat/pre-commit-golang" >> .pre-commit-config.yaml
        echo "    rev: master" >> .pre-commit-config.yaml
        echo "    hooks:" >> .pre-commit-config.yaml
        echo "    -   id: go-fmt-import" >> .pre-commit-config.yaml
        echo "    -   id: go-vet" >> .pre-commit-config.yaml
        echo "    -   id: go-lint" >> .pre-commit-config.yaml
    fi
fi

file_count=$(find . -name "*.tsx" | wc -l)
if [ $file_count -gt 0 ]; then
    echo "Typescript files detected. Installing eslint..."
    sudo npm install -g eslint
    if grep -q mirrors-eslint ".pre-commit-config.yaml"; then
        echo "Eslint exists in hook."
    else
        echo "Adding Eslint to hook."
        echo "-   repo: https://github.com/pre-commit/mirrors-eslint" >> .pre-commit-config.yaml
        echo "    rev: v6.8.0" >> .pre-commit-config.yaml
        echo "    hooks:" >> .pre-commit-config.yaml
        echo "    -   id: eslint" >> .pre-commit-config.yaml
	echo "        types: [file]" >> .pre-commit-config.yaml
	echo "        files: \.tsx?$" >> .pre-commit-config.yaml
    fi
fi

echo "==========Installing Pre-commt Hooks=========="
python3 -m pre_commit install

echo "==========Clean Up Setup Script=========="
if [ ! -f .gitignore ]; then
    echo ".gitignore does not exist. Creating..."
    echo "setup_precommit.sh" >> .gitignore
else
    if grep -q setup_precommit.sh ".gitignore"; then
            echo ".gitignore already set up for setup_precommit.sh."
    else
            echo "Configuring .gitignore"
            echo "setup_precommit.sh" >> .gitignore
    fi

    if grep -q .pre-commit-config.yaml ".gitignore"; then
            echo ".gitignore already set up for .pre-commit-config.yaml."
    else
            echo "Configuring .gitignore"
            echo ".pre-commit-config.yaml" >> .gitignore
    fi
fi

#rm setup_precommit.sh

