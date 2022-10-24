BIOS-611-Project-Midterm
===================

# Introduction: 

For my project, I will be looking at a diabetes health indicators dataset. This dataset contains 21 numeric features (some binary) such as whether or not patients have high blood pressure or high cholesterol, BMI, smoking status, etc. For each patient, they are either given a binary diabetes status, or a diabetes status in {0, 1, 2} signifying no diabetes, prediabetic, or has diabetes. I'm interested in analyzing this relationship to try to identify any potential relationships between the 21 patient attributes and diabetes status. 


# Instructions:

After cloning the repo, the dataset can be installed from: https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset. The three .csv files should be moved into the "source_data" directly. Then the docker container can be built with: 

- docker build . -t 611-proj   

Then Rstudio can be invoked with 

- docker run -v "$(pwd)":/home/rstudio/work -e PASSWORD=55 -p 8787:8787 -it 611-proj

In any browser, enter: 

- localhost:8787

with username: rstudio and password: 55 (or whatever password one chooses to set). Finally, in order to be able to make the final writeup, tinytex must be manually installed in Rstudio by going to the console and entering 

- tinytex::install_tinytex()

The directory can be cleaned in case there are any residual artifacts with "make clean." The final writeup can be generated by calling "make WriteUp-Midterm.pdf"


----------

# Initial Project Introduction [old assignment, now using different dataset]

Although the R_0 of monkeypox is widely considered to be far lower than that of the SARS-COV-2 virus, cases have also been observed in an increasing number of countries around the world. For both diseases, the true rates of transmission can vary widely based on regional and cultural differences. As such, I'm interested in taking a closer look at the case data for both of these diseases during the initial outbreak and spread of both diseases, which for monkeypox may still be in its early stages currently. In doing so, I'm interested in looking at the geographic patterns in spread at both global and localized levels and the various factors which may have contributed to the spread/containment of either virus including global policy, potential cultural differences of localized regions, as well as the inherent differences in the contagiousness of both diseases.

The datasets I'll be using are found at: 

	https://www.kaggle.com/datasets/lihyalan/2020-corona-virus-timeseries
    https://www.kaggle.com/datasets/deepcontractor/monkeypox-dataset-daily-updated

which contain day by day and even hourly data on the spread of these diseases during their initial onsets. Using this data, I'm interested in seeing whether there exist any similarities in the geographic spread of both diseases despite their differences. 

