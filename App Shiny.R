#LIBRERIAS
library(shiny)

ui <- fluidPage(
  titlePanel("Predicción de selección al All Star"),
  p("Ingrese las estadisticas promedio por partido de un jugador. El modelo estimara las probabilidad de ser seleccionado al All Star con esos números:"),
  sidebarLayout(
  sidebarPanel(h3("Estadísticas del jugador:"),
    sliderInput("PTS", "Promedio de puntos:", min = 0, max = 50, value = 0, step = 0.1),
    sliderInput("AST", "Promedio de asistencias:", min = 0, max = 15, value = 0, step = 0.1),
    sliderInput("TRB", "Promedio de rebotes:", min = 0, max = 25, value = 0, step = 0.1),
    sliderInput("STL", "Promedio de robos:", min = 0, max = 5, value = 0, step = 0.1),
    sliderInput("BLK", "Promedio de tapas:", min = 0, max = 5, value = 0, step = 0.1),
    actionButton("predecir", 
                 "Calcular probabilidad")),
  mainPanel(h2("Probabilidad de ser All-Star"),
    h1("—"),
    br(),
    h2("Clasificación estimada"),
    h2("—"))
  )
)


server <- function(input,output){}



shinyApp(ui, server)