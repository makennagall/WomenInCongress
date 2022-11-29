install.packages("rvest")
install.packages("stringr")
install.packages("readr")
install.packages("dplyr")
install.packages("plotly")
library(plotly)
library(rvest)
library(stringr)
library(readr)
library(dplyr)
install.packages("dplyr")
library(dplyr)
WomenInCongress <- read.csv("~/Downloads/WomenInCongress.csv")
library(readxl)
AllOutput <- read_excel("Desktop/AllOutput.xlsx")
colnames(AllOutput)
AllBillsNumbers <- read_excel("Desktop/AllBillsNumbers.xlsx")
colnames(AllBillsNumbers)
AllBillsNumbers <- mutate(AllBillsNumbers, percentWomen = (YesBills/TotalBills)* 100)
colnames(AllBillsNumbers)
plot_ly(data = AllBillsNumbers, type = "bar",
        x = ~Congress, y = ~percentWomen, color = ~TotalBills,
        hoverinfo = 'text',
        text = ~paste("Total Bills: ", TotalBills, "<br>", "Women in the Bills: ", YesBills))

AllOutput$monthday <- format(AllOutput$LatestActionDate, format="%m-%d")
monthday
AllOutput$LatestActionDate
colnames(WomenInCongress)
plot_ly(data = WomenInCongress, type = "scatter",
        x = ~Congress, y = ~Total.Women, color = ~Women.in.the.Senate,
        hoverinfo = 'text',
        text = ~paste("Women in the House: ", Women.in.the.House, "<br>", "Women in the Senate: ", Women.in.the.Senate))


plot_ly(data = AllOutput, type = "scatter",
        x = ~Congress, y = ~monthday, color = ~SponsorParty,
        hoverinfo = 'text',
        text = ~paste("Title:", BillTitle, "<br>", "URL:", URL))


plot_ly(data = AllOutput, type = "scatter", mode = "markers", 
        x = ~, y = ~TotRmsAbvGrd, frame = ~round(YearBuilt,-1),
        showlegend = FALSE) %>%
  animation_opts(frame = 1000, easing = "elastic", redraw = FALSE)

#left: returns all cases from the left (x) data table regardless of whether it has a matching y variable
joinedData <- left_join(x = AllOutput, y = WomenInCongress, by = "Congress")
joinedData
colnames(joinedData)

plot_ly(data = joinedData, type = "scatter",
        x = ~Congress, y = ~monthday, color = ~Total.Women,
        hoverinfo = 'text',
        text = ~paste("Title:", BillTitle, "<br>", "URL:", URL, "<br>Total Women: ", Total.Women))




