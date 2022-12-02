
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

library(shiny)
library(plotly)
library(forcats)
library(dplyr)
library(htmlwidgets)
library(ggplot2)

Frequency <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/frequency.csv')
WomenPerSession <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/WomenPerSession.csv')
AllOutput <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/compiledNewOutputs.csv')
TermsCount <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/termsCountNew.csv')
WomenPerSession <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/WomenPerSession.csv")


colnames(WomenPerSession)
colnames(AllOutput)

AllOutput$Congress <- as.integer(AllOutput$Congress)
WomenPerSession$Congress <- as.integer(WomenPerSession$Congress)
#add a date variable that contains day, month and year and is a Date object:
AllOutput <- mutate(AllOutput, date = paste(LatestActionMonth,"/",LatestActionDay,"/",LatestActionYear, sep = ""))
AllOutput$date <- as.Date(AllOutput$date, format = "%m/%d/%Y")
#add a DayMonth variable that is only the day and month so they can be displayed on the y axis:
AllOutput <- mutate(AllOutput, DayMonth = format(as.Date(date), "%m-%d"))
joinedData <- left_join(x = AllOutput, y = WomenPerSession, by = "Congress")
termDataJoined <- left_join(x = TermsCount, y = WomenPerSession, by = "Congress")
termDataJoined <- mutate(termDataJoined, date = paste(LatestActionMonth,"/",LatestActionDay,"/",LatestActionYear, sep = ""))
termDataJoined$date <- as.Date(termDataJoined$date, format = "%m/%d/%Y")
#add a DayMonth variable that is only the day and month so they can be displayed on the y axis:
termDataJoined <- mutate(termDataJoined, DayMonth = format(as.Date(date), "%m-%d"))


ui <- fluidPage(
  fluidRow(
    column(width = 4,
           plotOutput("plot1", height = 300,
                      click = "plot1_click",
                      brush = brushOpts(
                        id = "plot1_brush"
                      )
                  )
           )
  ),
  fluidRow(
    column(width = 6,
           h4("Points near click"),
           verbatimTextOutput("click_info")
    ),
    column(width = 6,
           h4("Brushed points"),
           verbatimTextOutput("brush_info")
    )
  ),
  plotlyOutput("plot2")
)
server <- function(input, output){
  output$plot1 <- renderPlot({
    ggplot(Frequency, aes(Term, Frequency)) + geom_point()
  })
  output$click_info <- renderPrint({
    nearPoints(Frequency, input$plot1_click, addDist = FALSE)
  })
  output$brush_info <- renderPrint({
    brushedPoints(Frequency, input$plot1_brush)
  })
  output$plot2 <- renderPlot({

    plot_ly(data = termDataJoined, type = "scatter", mode = "markers",
            x = ~LatestActionYear, y = ~DayMonth, color = ~Term,
            hoverinfo = 'text',
            text = ~paste("Title:", Title, "<br>", URL, "<br>Total Women: ", Total.Women, "<br>Sponsor: ", Sponsor, 
                          "<br>Sponsor Party: ", Sponsor.Party))
  })
}
# Run the application 
shinyApp(ui = ui, server = server)
