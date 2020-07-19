
library(shiny)
library(shinythemes)

####################################
# User Interface                   #
####################################
ui <- fluidPage(theme = shinytheme("united"),
                tags$head(
                    tags$style(HTML("
                        @media(max-width: 1020px){
                            body{
                            background-color: lightgrey;
                            }
                            .reverseWrap{
                                display:flex;
                                flex-wrap: wrap-reverse;
                            }
                            .reverseWrap > div{
                                width: 100%;
                            }
                            
                        }
                    "))
                ),

                
                
                navbarPage("Knoxville Micro Mobility:",
                           
                           tabPanel("Peak Times",
                                    tags$div(
                                        class="reverseWrap",
                                    
                                        # Input values
                                        sidebarPanel(
                                            class="inputPanel",
                                            HTML("<h3>Input parameters</h4>"),
                                            selectInput("xvar",
                                                        "Select the x variable:",
                                                        # VVV TODO REPLACE VVV
                                                        choices = c("A", "B", "C", "D")),
                                            selectInput("yvar",
                                                        "Select the y variable:",
                                                        # VVV TODO REPLACE VVV
                                                        choices = c("A", "B", "C", "D"),
                                            selectInput("fillcount",
                                                        "Select if wish to fill the scatter plot by county",
                                                        choices = c("Yes","No"),
                                                        selected = "No")
                                        ),
                                            
                                            actionButton("submitbutton", 
                                                         "Submit", 
                                                         class = "btn btn-primary")
                                        ),
                                        
                                        mainPanel(
                                            tags$label(h3('Status/Output')), # Status/Output Text Box
                                            verbatimTextOutput('contents'),
                                            tableOutput('tabledata') # Results table
                                        ) # mainPanel()
                                    ) # /div wrapper
                                    
                           ), #tabPanel(), Peak Times
                           
                           tabPanel("About", 
                                    titlePanel("About"), 
                                    div(includeMarkdown("about.md"), 
                                        align="justify")
                           ), #tabPanel(), About
                           tabPanel("Navbar 2", 
                                    "This panel is intentionally left blank"
                            )
                ) # navbarPage()
) # fluidPage()


####################################
# Server                           #
####################################
server <- function(input, output, session) {
    
    # Input Data
    datasetInput <- reactive({  
       
    })
    
    # Status/Output Text Box
    output$contents <- renderPrint({
        if (input$submitbutton>0) { 
            isolate("Calculation complete.") 
        } else {
            return("Server is ready for calculation.")
        }
    })
    
    # Prediction results table
    output$tabledata <- renderTable({
       
    })
    
}


####################################
# Create Shiny App                 #
####################################
shinyApp(
    ui = ui, 
    server = server
)
