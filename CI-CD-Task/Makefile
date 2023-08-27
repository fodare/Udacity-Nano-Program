install:
	python3 -m venv venv &&\
	pip install --upgrade pip &&\
	pip freeze > requirements.txt &&\
	pip install -r requirements.txt

test:
	python -m pytest -vv test_hello.py

lint:
	pylint --disable=R,C hello.py

all: install lint test