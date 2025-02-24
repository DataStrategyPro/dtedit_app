# Use the official R Shiny image as the base image
FROM rocker/shiny:latest

# Install required dependencies
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('renv', 'remotes', 'shiny', 'RSQLite', 'DBI', 'DT'), repos='http://cran.r-project.org/')"

# Install DTedit from GitHub
RUN R -e "remotes::install_github('jbryer/DTedit')"

# Create an app directory
WORKDIR /srv/shiny-server/

# Copy application files
COPY . /srv/shiny-server/

# Set appropriate permissions
RUN chown -R shiny:shiny /srv/shiny-server/

# Expose port 3838 for Shiny
EXPOSE 3838

# Run the Shiny app
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server', host='0.0.0.0', port=3838)"]

