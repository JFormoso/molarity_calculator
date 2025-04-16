# 🧪 Solutions Calculator Shiny App

This Shiny app allows you to perform basic chemical calculations based on **molarity, mass, volume**, and **molecular weight**. It retrieves molecular weights from PubChem using the [`webchem`](https://github.com/ropensci/webchem) package.

## 🚀 Features

Users can select from three calculation modes:

1. **Mass**  
   Calculates the amount of substance (in grams) from a given volume and concentration.

2. **Volume**  
   Determines the required volume (in mL) to obtain a given mass at a specific concentration.

3. **Molarity**  
   Computes molarity (mol/L) from mass and volume.

## 🧮 How It Works

- The user enters the **name of a compound** (e.g., `glucose`, `caffeine`).
- The app uses the `webchem` package to search PubChem for its **molecular weight**.
- The user inputs two of the following: mass, volume, or concentration.
- The app calculates the third value based on the selected mode.

## 💻 Tech Stack

- **R** and **Shiny**
- [`webchem`](https://docs.ropensci.org/webchem/) for retrieving molecular weight from PubChem
- [`shinythemes`](https://rstudio.github.io/shinythemes/) for styling
- [`renv`](https://docs.posit.co/ide/user/ide/guide/environments/r/renv.html) for project-specific package management and reproducibility

## 📦 How to use

To run the app locally, make sure you have R and the following packages installed:

`install.packages(c("shiny", "webchem", "shinythemes"))`

## 🧪 Example
Try entering:
- Compound: glucose
- Calculation mode: Mass from volume and concentration
- Concentration: 1 mM
- Volume: 1 mL

Output:
- Mass = 0.18016 g (based on glucose molecular weight ≈ 180.16 g/mol)

## 📄 License
MIT License. Feel free to use and adapt this project.

## 🙋‍♀️ Acknowledgments
This app uses open data provided by PubChem via the `webchem` package, maintained by [ropensci](https://ropensci.org/).



