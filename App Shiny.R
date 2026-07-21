#LIBRERIAS
library(shiny)
library(tidyverse)
library(bslib)

nba_rf <- readRDS("nba_rf.rds")

ui <- page_sidebar(
  tags$head(
    tags$style(HTML("
      .navbar-brand {
        font-size: 36px;
        font-weight: bold;
      }
    "))
  ),
  title = "Predicción de selección al All-Star",
  p("Ingrese las estadisticas promedio por partido de un jugador. El modelo estimara las probabilidad de ser seleccionado al All Star con esos números:"),
  theme = bs_theme(
    bootswatch = "flatly",
    primary = "#1D3557"
  ),
  sidebar = sidebar(
    h4("Estadísticas del jugador"),
    sliderInput("PTS", "Promedio de puntos", min = 0, max = 50, value = 0, step = 0.1),
    sliderInput("AST", "Promedio de asistencias", min = 0, max = 15, value = 0, step = 0.1),
    sliderInput("TRB", "Promedio de rebotes", min = 0, max = 25, value = 0, step = 0.1),
    sliderInput("STL", "Promedio de robos", min = 0, max = 5, value = 0, step = 0.1),
    sliderInput("BLK", "Promedio de tapas", min = 0, max = 5, value = 0, step = 0.1),
    br(),
    actionButton(
      "predecir",
      "Calcular probabilidad",
      class = "btn-primary"
    )
  ),
  layout_column_wrap(
    width = 1,
    card(
      card_header("📈 Probabilidad de ser All-Star"),
      card_body(
        div(
          style = "text-align:center;",
          h1(textOutput("probabilidad"))
        )
      )
    ),
    card(
      card_header("🏆 Clasificación estimada"),
      card_body(
        div(
          style = "text-align:center;",
          h2(textOutput("clasificacion"))
        )
      )
    )
  )
)

server <- function(input, output) {
  observeEvent(input$predecir, {
    nuevo_jugador <- tibble(
      TRB = input$TRB,
      AST = input$AST,
      STL = input$STL,
      BLK = input$BLK,
      PTS = input$PTS)
    probabilidad <- predict(
      nba_rf,
      new_data = nuevo_jugador,
      type = "prob")
    output$probabilidad <- renderText({
      paste0(round(probabilidad$.pred_Yes * 100, 1), "%")
    })
    clase <- predict(
      nba_rf,
      new_data = nuevo_jugador,
      type = "class")
    output$clasificacion <- renderText({
      if (clase$.pred_class == "Yes") {
        "All-Star"
      } else {
        "No All-Star"
      }
    })
    })
  }


shinyApp(ui, server)
