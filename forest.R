#create Forest plot for ORR in oncology study
#Author: Hengwei Liu

library(haven)
library(Hmisc)
library(shiny)
library(tidyr)
library(dplyr)
library(forestplot)

# Read in the SAS data
bor <- read_sas("bor.sas7bdat")
data.frame(bor)

# do race

bor1 <- bor[(bor$race=='Asian'),]
bor2 <- bor[(bor$race=='White'),]

n1 <- nrow(bor1)
x1 <- nrow(filter(bor1,bor1$avalc=="CR" | bor1$avalc=="PR"))

ci1 <- binconf(x1,n1,method="exact")
z1 <- round(100*ci1[1], digits=1)
low1 <- round(100*ci1[2], digits=1)
high1 <- round(100*ci1[3], digits=1)

n2 <- nrow(bor2)
x2 <- nrow(filter(bor2,bor2$avalc=="CR" | bor2$avalc=="PR"))

ci2 <- binconf(x2,n2,method="exact")
z2 <- round(100*ci2[1], digits=1)
low2 <- round(100*ci2[2], digits=1)
high2 <- round(100*ci2[3], digits=1)

# do gender

bor3 <- bor[(bor$sex=='Male'),]
bor4 <- bor[(bor$sex=='Female'),]

n3 <- nrow(bor3)
x3 <- nrow(filter(bor3,bor3$avalc=="CR" | bor3$avalc=="PR"))

ci3 <- binconf(x3,n3,method="exact")
z3 <- round(100*ci3[1], digits=1)
low3 <- round(100*ci3[2], digits=1)
high3 <- round(100*ci3[3], digits=1)

n4 <- nrow(bor4)
x4 <- nrow(filter(bor4,bor4$avalc=="CR" | bor4$avalc=="PR"))

ci4 <- binconf(x4,n4,method="exact")
z4 <- round(100*ci4[1], digits=1)
low4 <- round(100*ci4[2], digits=1)
high4 <- round(100*ci4[3], digits=1)

# do region

bor5 <- bor[(bor$region=='Japan'),]
bor6 <- bor[(bor$region=='USA'),]

n5 <- nrow(bor5)
x5 <- nrow(filter(bor5,bor5$avalc=="CR" | bor5$avalc=="PR"))

ci5 <- binconf(x5,n5,method="exact")
z5 <- round(100*ci5[1], digits=1)
low5 <- round(100*ci5[2], digits=1)
high5 <- round(100*ci5[3], digits=1)

n6 <- nrow(bor6)
x6 <- nrow(filter(bor6,bor6$avalc=="CR" | bor6$avalc=="PR"))

ci6 <- binconf(x6,n6,method="exact")
z6 <- round(100*ci6[1], digits=1)
low6 <- round(100*ci6[2], digits=1)
high6 <- round(100*ci6[3], digits=1)


rmeta <- 
  structure(list(
    orr  = c(NA, z1, z2, NA, z3, z4, NA, z5, z6), 
    lower = c(NA, low1, low2, NA, low3, low4, NA, low5, low6),
    upper = c(NA, high1, high2, NA, high3, high4, NA, high5, high6)),
    .Names = c("ORR", "Lower", "Upper"), 
    row.names = c(NA, -3L), 
    class = "data.frame")

tabletext<-cbind(
  c("Race", "Asian", "White", "Sex", "Male", "Female", "Region", "Japan", "USA"),
  c("ORR", z1, z2, "ORR", z3, z4, "ORR", z5, z6),
  c("Lower", low1, low2, "Lower", low3, low4, "Lower", low5, low6),
  c("Higher", high1, high2, "Higher", high3, high4, "Higher", high5, high6)
  )


ui <- fluidPage( 
  
  mainPanel( plotOutput("fstPlot") 
  ) 
  
) 

server <- function(input, output) {
  output$fstPlot <- renderPlot({ 
  myPlot <- forestplot(tabletext, 
             rmeta,
             is.summary=FALSE,
             
             xticks.digits=0, 
             xticks=c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
             
  )
    print(myPlot) })
  
}


shinyApp(ui=ui, server=server)


