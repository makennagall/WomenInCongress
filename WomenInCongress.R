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

#Old Bill Data:
OldAllOutput <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/OldData/AllOutputs.csv")
OldAllBillsNumbers <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/OldData/AllBillsNumbers.csv")
OldtermsCount <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/OldData/termsCount.csv')

#New Bill Data:
AllBillsNumbers <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/NewBillNumbers.csv")
Frequency <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/frequency.csv')
WomenPerSession <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/WomenPerSession.csv')
AllOutput <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/compiledNewOutputs.csv')
TermsCount <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/termsCountNew.csv')

#Adjust/Combine Data:
  #Change Congress to integer:
  AllOutput$Congress <- as.integer(AllOutput$Congress)
  #Add Percent Women to AllBillsNumbers:
  AllBillsNumbers <- mutate(AllBillsNumbers, percentWomen = (YesBills/Total)* 100)
  #change LatestAction Date to Date object:
  AllOutput$date <- as.Date(AllOutput$LatestActionDate, format = "%m/%d/%y")
  TermsCount$date <- as.Date(TermsCount$LatestActionDate, format = "%m/%d/%y")
  #add a DayMonth variable that is only the day and month so they can be displayed on the y axis:
  AllOutput <- mutate(AllOutput, DayMonth = format(as.Date(date), "%m-%d"))
  TermsCount <- mutate(AllOutput, DayMonth = format(as.Date(date), "%m-%d"))
  #join data:
  joinedData <- left_join(x = AllOutput, y = WomenPerSession, by = "Congress")
  termDataJoined <- left_join(x = TermsCount, y = WomenPerSession, by = "Congress")
  BillNumbersAndWomenPerSesh <- left_join(x = WomenPerSession, y = AllBillsNumbers, by = "Congress")

#Draw Plotly Graphs:
billPercentPlot <- plot_ly(data = BillNumbersAndWomenPerSesh, type = "bar",
        x = ~Congress, y = ~percentWomen, color = ~Total.Women,
        hoverinfo = 'text',
        text = ~paste("Total Bills: ", Total, "<br>", "Women in the Bills: ", YesBills, "<br>Women in Congress: ", Total.Women))
billPercentPlot <- billPercentPlot %>% layout( 
        legend = list(title = list( text = "<br>Total<br>Women<br>")),
        title = "Congress v. Percentage of Bills", 
        yaxis = list(title = "Bills that Contain Terms Related to Women (Percent)"))

billNumberPlot <- plot_ly(data = BillNumbersAndWomenPerSesh, type = "bar",
        x = ~Congress, y = ~YesBills, color = ~Total.Women,
        hoverinfo = 'text',
        text = ~paste("Total Bills: ", Total, "<br>", "Women in the Bills: ", YesBills, "<br>Women in Congress: ", Total.Women))
billNumberPlot <- billNumberPlot %>% layout(
        legend = list(orientation = 'h', title = list(text = 'Women<br>in Congress<br>'), 
        title = "Congress v. Number of Bills", 
        yaxis = list(title = "Bills that Contain Terms Related to Women")
        ))

numWomenPlot <- plot_ly(data = BillNumbersAndWomenPerSesh, type = "bar",
        x = ~Congress, y = ~Total.Women, color = ~percentWomen,
        hoverinfo = 'text',
        text = ~paste("Women in the House: ", Women.in.the.House, "<br>", "Women in the Senate: ", Women.in.the.Senate))%>%
          layout(title = "Congress v. Women in Congress", yaxis = list(title = "Women in Congress"),
                 legend = list(title = list( text = "<br>Percent<br>of Bills<br>")))

byPartyPlot <- plot_ly(data = AllOutput, type = "scatter", mode = "markers",
        x = ~LatestActionYear, y = ~DayMonth, color = ~SponsorParty, legendgrouptitle = "Party",
        hoverinfo = 'text',
        text = ~paste("Title:", Title, "<br>", "URL:", URL))


indBillsCongressionalWomen <- plot_ly(data = joinedData, type = "scatter", mode = "markers",
        x = ~Congress, y = ~DayMonth, color = ~Total.Women,
        hoverinfo = 'text',
        text = ~paste("Title:", Title, "<br>", URL, "<br>Total Women: ", Total.Women, "<br>Sponsor: ", Sponsor, 
                      "<br>Sponsor Party: ", SponsorParty))

plot_ly(data = termDataJoined, 
        type = "scatter", 
        mode = "markers",
        x = ~Term, 
        y = ~Congress, 
        hoverinfo = 'text',
        text = ~paste("Title:", Title, "<br>", URL, "<br>Total Women: ", Total.Women, "<br>Sponsor: ", Sponsor, 
                      "<br>Sponsor Party: ", Sponsor.Party))

plot_ly(data = Frequency, 
        type = 'bar', 
        x = ~fct_reorder(Term, Frequency), 
        y = ~Frequency, 
        color = 'green',
        hoverinfo = 'text',
        text = ~paste("Term:", Term, "<br>Frequency", Frequency))

plot_ly(data = termDataJoined, type = "scatter", mode = "markers",
        x = ~LatestActionYear, y = ~DayMonth, color = ~Term,
        hoverinfo = 'text',
        text = ~paste("Title:", Title, "<br>", URL, "<br>Total Women: ", Total.Women, "<br>Sponsor: ", Sponsor, 
                      "<br>Sponsor Party: ", Sponsor.Party))

#Make Plots:
billPercentPlot
billNumberPlot
numWomenPlot
byPartyPlot
indBillsCongressionalWomen
