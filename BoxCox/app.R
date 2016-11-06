library(shiny)

ui <- fluidPage(
   titlePanel("Australian Monthly Electricity Demand"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel(
         sliderInput("lambda",
                     "Transformation parameter: λ",
                     min = -1,
                     max = 2,
                     value = 1,
                     step=0.1)
      ),

      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("elecPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

   output$elecPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      ggplot2::autoplot(forecast::BoxCox(fma::elec,input$lambda)) +
        ggplot2::ylab("Transformed electricity demand") +
        ggplot2::xlab("Year")
   })
}

# Run the application
shinyApp(ui = ui, server = server)

