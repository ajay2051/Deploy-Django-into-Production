FROM python:3.11

# Set work directory
WORKDIR /usr/src/app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && cat apt_requirements.txt | xargs apt -y --no-install-recommends install \
    && rm -rf /var/lib/apt/lists/* \
    && apt autoremove \
    && apt autoclean

# Install Python dependencies
RUN pip install --upgrade pip
COPY requirements.txt /usr/src/app/requirements.txt
RUN pip install -r requirements.txt

COPY . /usr/src/app/


RUN chmod +x /usr/src/app/entrypoint.sh

RUN chmod -R 777 /usr/src/app
EXPOSE 8000
# Set the entrypoint
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]