install.packages("rvest")
install.packages("stringr")
install.packages("readr")
install.packages("dplyr")
install.packages("plotly")
install.packages("lubridate")
install.packages("forcats") # for processing categorical data
library(plotly)
library(rvest)
library(stringr)
library(readr)
library(dplyr)
library(lubridate)
library(forcats)

WomenPerSession <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/WomenPerSession.csv")
OldAllOutput <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/OldData/AllOutputs.csv")
OldAllBillsNumbers <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/OldData/AllBillsNumbers.csv")
OldtermsCount <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/OldData/termsCount.csv')
AllBillsNumbers <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/NewBillNumbers.csv")
AllBillsNumbers <- mutate(AllBillsNumbers, percentWomen = (YesBills/Total)* 100)
Frequency <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/frequency.csv')
WomenPerSession <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/WomenPerSession.csv')
AllOutput <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/compiledNewOutputs.csv')
TermsCount <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/termsCountNew.csv')

colnames(OldAllOutput)
colnames(OldAllBillsNumbers)
colnames(TermsCount)
View(TermsCount)
colnames(WomenPerSession)
colnames(AllOutput)
AllOutput$Congress

#add a date variable that contains day, month and year and is a Date object:
AllOutput <- mutate(AllOutput, date = paste(LatestActionMonth,"/",LatestActionDay,"/",LatestActionYear, sep = ""))
AllOutput$date <- as.Date(AllOutput$date, format = "%m/%d/%Y")
#add a DayMonth variable that is only the day and month so they can be displayed on the y axis:
AllOutput <- mutate(AllOutput, DayMonth = format(as.Date(date), "%m-%d"))

#A graph with:
#x axis: Congressional Session
#y axis: percent of the bills written that contained a key term pertaining to women or other gender minorities
#color: total number of women in congress for that session
WomenPerSession$Congress <- as.integer(WomenPerSession$Congress)
TermsCount$Congress <- as.integer(TermsCount$Congress)
joinedData <- left_join(x = AllOutput, y = WomenPerSession, by = "Congress")
joinedData$Congress <- as.integer(joinedData$Congress)
termDataJoined <- left_join(x = TermsCount, y = WomenPerSession, by = "Congress")
BillNumbersAndWomenPerSesh <- left_join(x = WomenPerSession, y = AllBillsNumbers, by = "Congress")
plot_ly(data = BillNumbersAndWomenPerSesh, type = "bar",
        x = ~Congress, y = ~percentWomen, color = ~Total.Women,
        hoverinfo = 'text',
        text = ~paste("Total Bills: ", Total, "<br>", "Women in the Bills: ", YesBills, "<br>Women in Congress: ", Total.Women))%>%
          layout(title = "Congress v. Percentage of Bills", yaxis = list(title = "Bills that Contain Terms Related to Women (Percent)"),
          legend = list(title = list( text = "<br>Total<br>Women<br>")))
#reformats the year to contain only the month and day, so it can be more easily displayed in a timeline format

plot_ly(data = BillNumbersAndWomenPerSesh, type = "bar",
        x = ~Congress, y = ~YesBills, color = ~Total.Women,
        hoverinfo = 'text',
        text = ~paste("Total Bills: ", Total, "<br>", "Women in the Bills: ", YesBills, "<br>Women in Congress: ", Total.Women))%>%
  layout(title = "Congress v. Number of Bills", yaxis = list(title = "Bills that Contain Terms Related to Women"),
         legend = list(title = list( text = "<br>Total<br>Women<br>")))
#reformats the year to contain only the month and day, so it can be more easily displayed in a timeline format

plot_ly(data = BillNumbersAndWomenPerSesh, type = "bar",
        x = ~Congress, y = ~Total.Women, color = ~percentWomen,
        hoverinfo = 'text',
        text = ~paste("Women in the House: ", Women.in.the.House, "<br>", "Women in the Senate: ", Women.in.the.Senate))%>%
          layout(title = "Congress v. Women in Congress", yaxis = list(title = "Women in Congress"),
                 legend = list(title = list( text = "<br>Percent<br>of Bills<br>")))

#A graph with:
#x axis: Year of Latest Update
#y axis: Month and Day of Latest Update
#color: Party that sponsored the bill
plot_ly(data = AllOutput, type = "scatter", mode = "markers",
        x = ~LatestActionYear, y = ~DayMonth, color = ~SponsorParty, legendgrouptitle = "Party",
        hoverinfo = 'text',
        text = ~paste("Title:", Title, "<br>", "URL:", URL))

#left: returns all cases from the left (x) data table regardless of whether it has a matching y variable


plot_ly(data = joinedData, type = "scatter", mode = "markers",
        x = ~Congress, y = ~DayMonth, color = ~Total.Women,
        hoverinfo = 'text',
        text = ~paste("Title:", Title, "<br>", URL, "<br>Total Women: ", Total.Women, "<br>Sponsor: ", Sponsor, 
                      "<br>Sponsor Party: ", SponsorParty))

#add a date variable that contains day, month and year and is a Date object:

View(termDataJoined)
plot_ly(data = termDataJoined, 
        type = "scatter", 
        mode = "markers",
        x = ~term, 
        y = ~Congress, 
        hoverinfo = 'text',
        text = ~paste("Title:", title, "<br>", URL, "<br>Total Women: ", Total.Women, "<br>Sponsor: ", Sponsor))

plot_ly(data = Frequency, 
        type = 'bar', 
        x = ~fct_reorder(Term, Frequency), 
        y = ~Frequency, 
        color = 'green',
        hoverinfo = 'text',
        text = ~paste("Term:", Term, "<br>Frequency", Frequency))


