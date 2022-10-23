BIOS-611-Project
===================

Useful commands:

- docker build . -t 611-proj   
- docker run -v "$(pwd)":/home/rstudio/work -e PASSWORD=55 -p 8787:8787 -it 611-proj

- goto localhost:8787 / user: rstudio / pass: 55

Dataset: 

https://www.kaggle.com/code/alexteboul/diabetes-health-indicators-dataset-notebook/notebook


----------

#Project Introduction [old assignment]

Although the R_0 of monkeypox is widely considered to be far lower than that of the SARS-COV-2 virus, cases have also been observed in an increasing number of countries around the world. For both diseases, the true rates of transmission can vary widely based on regional and cultural differences. As such, I'm interested in taking a closer look at the case data for both of these diseases during the initial outbreak and spread of both diseases, which for monkeypox may still be in its early stages currently. In doing so, I'm interested in looking at the geographic patterns in spread at both global and localized levels and the various factors which may have contributed to the spread/containment of either virus including global policy, potential cultural differences of localized regions, as well as the inherent differences in the contagiousness of both diseases.

The datasets I'll be using are found at: 

	https://www.kaggle.com/datasets/lihyalan/2020-corona-virus-timeseries
    https://www.kaggle.com/datasets/deepcontractor/monkeypox-dataset-daily-updated

which contain day by day and even hourly data on the spread of these diseases during their initial onsets. Using this data, I'm interested in seeing whether there exist any similarities in the geographic spread of both diseases despite their differences. 

