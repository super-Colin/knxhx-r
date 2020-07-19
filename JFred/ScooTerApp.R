#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

load("Scoot.RData")



save(data,day_plot,hour_plot,SCOOT, PLOTS, file = "Scoot.RData")

ui <- fluidPage(
    
    # Application title
    titlePanel("Scooter Data"),
    
    # Sidebar with a slider input for number of bins 
    tabsetPanel(tabPanel("Custom Plots",
                         sidebarLayout(
                             sidebarPanel(
                                 selectInput("x1",
                                             "select x", 
                                             choices = c("Hour","Month","Wday", "LagDemandDay")),
                                 selectInput("y",
                                             "select y", 
                                             choices = c("HourlyPerDay","DemandDay","RoughDist")),
                                 selectInput("fill", "select a var to fill",
                                             choices = c("None", "Hour", "Month","Wday"))
                             ),
                             
                             
                             
                             
                             
                             
                             # Show a plot of the generated distribution
                             mainPanel(
                                 plotOutput("distPlot")
                             )
                         )
    ), 
    tabPanel("Other Plots",
             sidebarLayout(
                 sidebarPanel(
                     selectInput("dayHour",
                                 "Select Day Or Hour",
                                 choices = c("Day","Hour"))
                 ),
                 mainPanel(
                     plotOutput("distPlot2")
                 )
             )
    )
    )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
    library(ggplot2)
    output$distPlot <- renderPlot({
        
        if(input$fill=="None"){
            PLOTS(input$x1,input$y, data = SCOOT)
        }else{
            PLOTS(input$x1,input$y, data = SCOOT, fill = input$fill)
        }
        
        #plot cannot have y as a catergorcial var 
    })
    
    output$distPlot2 <- renderPlot({
        if(input$dayHour=="Day"){
            ggplot(day_plot, aes(x = Day, y = counts)) + 
                geom_bar(fill = "#0073C2FF", stat = "identity") +
                geom_text(aes(label = counts), vjust = -0.3)
        }else{
            ggplot(hour_plot, aes(x = Time, y = counts)) + 
                geom_bar(fill = "#0073C2FF", stat = "identity") +
                geom_text(aes(label = counts), vjust = -0.3)
        }
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
