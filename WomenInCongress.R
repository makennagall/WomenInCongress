install.packages("rvest")
install.packages("stringr")
install.packages("readr")
install.packages("dplyr")
install.packages("plotly")
install.packages("lubridate")

library(plotly)
library(rvest)
library(stringr)
library(readr)
library(dplyr)
library(lubridate)

WomenInCongress <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/WomenPerSession.csv")
AllOutput <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/AllOutputs.csv")
colnames(AllOutput)
AllBillsNumbers <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/AllBillsNumbers.csv")
colnames(AllBillsNumbers)
AllBillsNumbers <- mutate(AllBillsNumbers, percentWomen = (Yes.Bills/Total.Bills)* 100)
colnames(AllBillsNumbers)
termsCount <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/termsCount.csv')
colnames(termsCount)
#A graph with:
#x axis: Congressional Session
#y axis: percent of the bills written that contained a key term pertaining to women or other gender minorities
#color: total number of bills available on congress.gov for that session
plot_ly(data = AllBillsNumbers, type = "bar",
        x = ~Congress, y = ~percentWomen, color = ~Total.Bills,
        hoverinfo = 'text',
        text = ~paste("Total Bills: ", Total.Bills, "<br>", "Women in the Bills: ", Yes.Bills))
#reformats the year to contain only the month and day, so it can be more easily displayed in a timeline format

colnames(WomenInCongress)
plot_ly(data = WomenInCongress, type = "scatter", mode= 'lines',
        x = ~Congress, y = ~Total.Women,
        hoverinfo = 'text',
        text = ~paste("Women in the House: ", Women.in.the.House, "<br>", "Women in the Senate: ", Women.in.the.Senate))
#add a date variable that contains day, month and year and is a Date object:
AllOutput <- mutate(AllOutput, date = paste(LatestActionMonth,"/",LatestActionDay,"/",Latest.Action.Year, sep = ""))
AllOutput$date <- as.Date(AllOutput$date, format = "%m/%d/%Y")
#add a DayMonth variable that is only the day and month so they can be displayed on the y axis:
AllOutput <- mutate(AllOutput, DayMonth = format(as.Date(date), "%m-%d"))
#A graph with:
#x axis: Year of Latest Update
#y axis: Month and Day of Latest Update
#color: Party that sponsored the bill
plot_ly(data = AllOutput, type = "scatter", mode = "markers",
        x = ~Latest.Action.Year, y = ~DayMonth, color = ~SponsorParty, legendgrouptitle = "Party",
        hoverinfo = 'text',
        text = ~paste("Title:", BillTitle, "<br>", "URL:", URL))

#left: returns all cases from the left (x) data table regardless of whether it has a matching y variable
joinedData <- left_join(x = AllOutput, y = WomenInCongress, by = "Congress")
joinedData
colnames(joinedData)
joinedData$Sponsor <- paste(joinedData$Sponsor," (",joinedData$SponsorParty,")", sep = "")
plot_ly(data = joinedData, type = "scatter", mode = "markers",
        x = ~Congress, y = ~DayMonth, color = ~Total.Women,
        hoverinfo = 'text',
        text = ~paste("Title:", BillTitle, "<br>", URL, "<br>Total Women: ", Total.Women, "<br>Sponsor: ", Sponsor))

termDataJoined <- left_join(x = termsCount, y = WomenInCongress, by = "Congress")
termDataJoined <- mutate(termDataJoined, date = paste(LatestActionMonth,"/",LatestActionDay,"/",LatestActionYear, sep = ""))
termDataJoined$date <- as.Date(termDataJoined$date, format = "%m/%d/%Y")
termDataJoined <- mutate(termDataJoined, DayMonth = format(as.Date(date), "%m-%d"))
colnames(termDataJoined)
plot_ly(data = termDataJoined, type = "scatter", mode = "markers",
        x = ~DayMonth, y = ~LatestActionYear, color = ~term,
        hoverinfo = 'text',
        text = ~paste("Title:", title, "<br>", URL, "<br>Total Women: ", Total.Women, "<br>Sponsor: ", Sponsor))

plot_ly(data = termDataJoined, type = "scatter", mode = "markers",
        x = ~Congress, y = ~term, color = ~Total.Women,
        hoverinfo = 'text',
        text = ~paste("Title:", title, "<br>", URL, "<br>Total Women: ", Total.Women, "<br>Sponsor: ", Sponsor))

frequency <- data.frame(table(termDataJoined$term))
typeof(frequency$Var1)
View(frequency)
termDataJoined <- left_join(x = termDataJoined, y = frequency, by = "Congress")

