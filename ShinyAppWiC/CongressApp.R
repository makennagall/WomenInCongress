
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

library(shiny)
OldtermsCount <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/OldData/termsCount.csv')

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Women in Congress"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    position = "left",
    sidebarPanel(
      checkboxGroupInput("terms", h3("Term List"),
                   choices = list("choice 1" = 1, "choice 2" = 2), selected = 1),
      sliderInput("StartCongress",
                  "Congressional Sessions:",
                  min = 82,
                  max = 117,
                  value = c(0,100))),
    
    # Show a plot of the generated distribution
    mainPanel(
      h1("Women in Congress Graph", align = 'center'),
      plotOutput("distPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = StartCongress, col = 'darkgray', border = 'orange',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
