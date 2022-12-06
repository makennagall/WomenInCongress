#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(rvest)
library(stringr)
library(readr)
library(dplyr)
library(lubridate)
library(forcats)

#Load in Data:
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
AllOutput$Date <- as.Date(AllOutput$Date, format = "%m/%d/%y")
TermsCount$Date <- as.Date(TermsCount$Date, format = "%m/%d/%y")
#add a DayMonth variable that is only the day and month so they can be displayed on the y axis:
AllOutput <- mutate(AllOutput, DayMonth = format(as.Date(Date), "%m-%d"))
TermsCount <- mutate(TermsCount, DayMonth = format(as.Date(Date), "%m-%d"))
#join data:
joinedData <- left_join(x = AllOutput, y = WomenPerSession, by = "Congress")
termDataJoined <- left_join(x = TermsCount, y = WomenPerSession, by = "Congress")
termDataJoined <- left_join(x = termDataJoined, y = Frequency, by = "Term")
BillNumbersAndWomenPerSesh <- left_join(x = AllBillsNumbers, y = WomenPerSession, by = "Congress")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Women in Congress"),
        # Show a plot of the generated distribution
        mainPanel(
          #Make Plots:
          plotlyOutput("byTermPlot"),
          plotlyOutput("indBillsCongressionalWomen"),
          plotlyOutput("billPercentPlot"),
          plotlyOutput("billNumberPlot"),
          plotlyOutput("numWomenPlot"),
          plotlyOutput("byPartyPlot"),
          plotlyOutput("TermFrequencyPlot")

        )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #Draw Plotly Graphs:
  output$billPercentPlot <- renderPlotly({
    plot_ly(data = BillNumbersAndWomenPerSesh, 
    type = "bar",
    x = ~Congress, 
    y = ~percentWomen, 
    color = ~TotalWomen,
    colors = c("slategray2", "mediumpurple1"),
    hoverinfo = 'text',
    text = ~paste("Congress: ", Congress, "<br>Years: ", StartYear, "-", EndYear, "<br>Total Bills: ", Total, "<br>", "Women in the Bills: ", YesBills, "<br>Women in Congress: ", TotalWomen))%>% layout( 
    legend = list(title = list( text = "<br>Total<br>Women<br>")),
    title = "Congress v. Percentage of Bills", 
    yaxis = list(title = "Bills that Contain Terms Related to Women (Percent)"))})
  
  output$billNumberPlot <- renderPlotly({
    plot_ly(data = BillNumbersAndWomenPerSesh, 
    type = "bar",
    x = ~Congress, 
    y = ~YesBills, 
    color = ~TotalWomen,
    colors = c("slategray2", "mediumpurple1"),
    hoverinfo = 'text',
    text = ~paste("Congress: ", Congress, "<br>Years: ", StartYear, "-", EndYear, "<br>Total Bills: ", Total, "<br>", "Women in the Bills: ", YesBills, "<br>Women in Congress: ", TotalWomen))%>% layout(
    legend = list(orientation = 'h', title = list(text = 'Women<br>in Congress<br>')), 
    title = "Congress v. Number of Bills", 
    yaxis = list(title = "Number of Bills that Contain Terms Related to Women"))})
  
  output$numWomenPlot <- renderPlotly({plot_ly(data = BillNumbersAndWomenPerSesh, type = "bar",
                                 x = ~Congress, y = ~TotalWomen, color = ~percentWomen,
                                 colors = c("slategray2", "mediumpurple1"),
                                 hoverinfo = 'text',
                                 text = ~paste("Congress: ", Congress, "<br>Years: ", StartYear, "-", EndYear, "<br>Women in the House: ", WomeninHouse, "<br>", "Women in the Senate: ", WomeninSenate, "<br>Percent of Bills about Women: ", percentWomen, "<br>Bills About Women: ", YesBills))%>%layout(title = "Congress v. Women in Congress", yaxis = list(title = "Women in Congress"),
           legend = list(title = list( text = "<br>Percent<br>of Bills<br>")))})
  
  output$byPartyPlot <- renderPlotly({plot_ly(data = AllOutput, type = "scatter", mode = "markers",
                                x = ~LatestActionYear, 
                                y = ~DayMonth, 
                                color = ~SponsorParty,
                                colors = c("blue", "green", "gray", "red"),
                                hoverinfo = 'text',
                                text = ~paste("Title:", Title, "<br>Date of Latest Action: ", LatestActionMonth, "/", LatestActionDay, "/", LatestActionYear, "<br>URL:", URL, "<br>Sponsor: ", Sponsor))})
  
  
  output$indBillsCongressionalWomen <- renderPlotly({plot_ly(data = joinedData, type = "scatter", mode = "markers",
                                               x = ~Congress, 
                                               y = ~DayMonth, 
                                               color = ~TotalWomen,
                                               colors = c("slategray2", "mediumpurple1"),
                                               hoverinfo = 'text',
                                               text = ~paste("Title:", Title, "<br>Date of Latest Action: ", LatestActionMonth, "/", LatestActionDay, "/", LatestActionYear, "<br>URL: ", URL, "<br>Total Women: ", TotalWomen, "<br>Sponsor: ", Sponsor, 
                                                             "<br>Sponsor Party: ", SponsorParty))%>%layout(
    legend = list(title = list(text = "Women<br>in Congress")),
    title = "Timeline of Bills about Women<br>and Number of Women in Congress",
    yaxis = list(title = "Day - Month"),
    xaxis = list(title = "Congress")
  )})
  
  output$TermFrequencyPlot <- renderPlotly({plot_ly(data = Frequency, 
                                      type = 'bar', 
                                      x = ~fct_reorder(Term, Frequency), 
                                      y = ~Frequency,
                                      colors = c("slategray2"),
                                      hoverinfo = 'text',
                                      text = ~paste("Term:", Term, "<br>Frequency", Frequency))%>%layout(
    title = "Frequency of Term Usage",
    yaxis = list(title = "Number of Bills"),
    xaxis = list(title = "Term")
  )})
  
  output$byTermPlot <- renderPlotly({plot_ly(data = termDataJoined, type = "scatter", mode = "markers",
                               x = ~LatestActionYear, 
                               y = ~DayMonth, 
                               color = ~fct_reorder(Term, Frequency, .desc=TRUE),
                               colors = c("lightcoral", "seagreen3", 'cornflowerblue',"lightsalmon1", "palegreen","plum",  "steelblue1", "slategray2", "lightslateblue",
                                          'mediumturquoise', "darkseagreen3", "cadetblue3", 'darksalmon', "aquamarine1", "darkolivegreen2", "gold","deepskyblue", "indianred1", 
                                          "lightgoldenrod2", "lightpink", "orange1", "mediumaquamarine", "pink2",  "mediumpurple1", "lightskyblue1", "darkslategray1", "chocolate1"),
                               hoverinfo = 'text',
                               text = ~paste("Title:", Title,"<br>Date of Latest Action: ", LatestActionMonth, "/", LatestActionDay, "/", LatestActionYear, "<br>URL: ", URL, "<br>Total Women: ", TotalWomen, "<br>Sponsor: ", Sponsor, 
                                             "<br>Sponsor Party: ", SponsorParty))%>%layout(
    legend = list(title = list(text = "Terms")),
    title = "Timeline of Term Usage",
    yaxis = list(title = "Month - Day"),
    xaxis = list(title = "Year"))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
