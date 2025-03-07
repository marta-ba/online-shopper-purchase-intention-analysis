library(caret)
library(corrplot)
library(gmodels)
library(ggplot2)
library(doParallel)
library(ROCR)
library(party)
library(rpart)
library(randomForest)
library(C50)
library(CHAID)
library(gbm)
library(pROC)
library(psych)
library(rpart.plot)
library(plyr)
library(DMwR)
library(dplyr)
library(gridExtra)
library(GGally)
library(formattable)
library(kableExtra)

#leemos las BB.DDatos
#Establecemos el directorio de trabajo;
setwd("C:/Users/smans/Documents/sara/Master/Modulo 5/Examen")
datos <-read.csv("online_shoppers_intention.csv", header = T, sep=",", dec = ".")
head(datos)

str(datos)

datos_orig<-datos

summary(datos)

#Convierto a factor variables lógicas.
datos$Weekend<-as.numeric(datos$Weekend)
datos$Revenue<-as.numeric(datos$Revenue)
datos$Weekend<-ifelse(datos$Weekend =='0','no','yes')
datos$Revenue<-ifelse(datos$Revenue =='0', 'no', 'yes')
datos$Weekend<-as.factor(datos$Weekend)
datos$Revenue<-as.factor(datos$Revenue)
levels(datos$Revenue)

levels(datos$Weekend)

#Convierto a factor variables numéricas:
#specialDay consideramos 0: lejano a festivo 1: proximo a festivo
datos$SpecialDay<-ifelse(datos$SpecialDay == 0 , 1, 0)
datos$SpecialDay<-as.factor(datos$SpecialDay)

datos$OperatingSystems <-as.factor(datos$OperatingSystems)     
datos$Browser<-as.factor(datos$Browser)    
datos$Region<-as.factor(datos$Region)       
datos$TrafficType<-as.factor(datos$TrafficType)       
datos$VisitorType<-as.factor(datos$VisitorType)

#compruebo la estructura de la BB.DD
str(datos)

library(DataExplorer)

#identificacion de las variables con valores missing
introduce(datos)

#graficamente
plot_intro(datos)

sapply(datos, function(x) sum(is.na(x)))

ggplot(data = datos, aes(x = Revenue, y = ..count.., fill = Revenue)) +
  geom_bar() +
  scale_fill_manual(values = c("gray50", "orangered2")) +
  labs(title = "Ingresos") +
  theme_bw() +
  theme(legend.position = "bottom")

prop.table(table(datos$Revenue)) %>% round(2)

#Weekend
ggplot(data = datos, aes(x = Weekend, y = ..count.., fill = Revenue)) +
  geom_bar() +
  scale_fill_manual(values = c("gray50", "orangered2")) +
  labs(title = "Weekend") +
  theme_bw() +
  theme(legend.position = "bottom")

#tabla de frecuencias

# Tabla de frecuencias 
prop.table(table(datos$Weekend, datos$Revenue), margin = 1) %>% round(digits = 2)

table(datos$Weekend, datos$Revenue)

#Month
ggplot(data = datos, aes(x = Month, y = ..count.., fill = Revenue)) +
  geom_bar() +
  scale_fill_manual(values = c("gray50", "orangered2")) +
  labs(title = "Month") +
  theme_bw() +
  theme(legend.position = "bottom")

#tabla de frecuencias

# Tabla de frecuencias 
prop.table(table(datos$Month, datos$Revenue), margin = 1) %>% round(digits = 2)

table(datos$Month, datos$Revenue)

#VisitorType
ggplot(data = datos, aes(x = VisitorType, y = ..count.., fill = Revenue)) +
  geom_bar() +
  scale_fill_manual(values = c("gray50", "orangered2")) +
  labs(title = "visitorType") +
  theme_bw() +
  theme(legend.position = "bottom")

#tabla de frecuencias

# Tabla de frecuencias 
prop.table(table(datos$VisitorType, datos$Revenue), margin = 1) %>% round(digits = 2)

table(datos$VisitorType, datos$Revenue)

#Operating systems
ggplot(data = datos, aes(x = OperatingSystems, y = ..count.., fill = Revenue)) +
  geom_bar() +
  scale_fill_manual(values = c("gray50", "orangered2")) +
  labs(title = "Operating Systems") +
  theme_bw() +
  theme(legend.position = "bottom")

#tabla de frecuencias

# Tabla de frecuencias 
prop.table(table(datos$OperatingSystems, datos$Revenue), margin = 1) %>% round(digits = 2)

table(datos$OperatingSystems, datos$Revenue)

#Navegador
ggplot(data = datos, aes(x = Browser, y = ..count.., fill = Revenue)) +
  geom_bar() +
  scale_fill_manual(values = c("gray50", "orangered2")) +
  labs(title = "Browser") +
  theme_bw() +
  theme(legend.position = "bottom")

#tabla de frecuencias

# Tabla de frecuencias 
prop.table(table(datos$Browser, datos$Revenue), margin = 1) %>% round(digits = 2)

table(datos$Browser, datos$Revenue)

#Region
ggplot(data = datos, aes(x = Region, y = ..count.., fill = Revenue)) +
  geom_bar() +
  scale_fill_manual(values = c("gray50", "orangered2")) +
  labs(title = "Region") +
  theme_bw() +
  theme(legend.position = "bottom")

#tabla de frecuencias

# Tabla de frecuencias 
prop.table(table(datos$Region, datos$Revenue), margin = 1) %>% round(digits = 2)

table(datos$Region, datos$Revenue)

#TrafficType
ggplot(data = datos, aes(x = TrafficType, y = ..count.., fill = Revenue)) +
  geom_bar() +
  scale_fill_manual(values = c("gray50", "orangered2")) +
  labs(title = "Trafic Type") +
  theme_bw() +
  theme(legend.position = "bottom")

#tabla de frecuencias

# Tabla de frecuencias 
prop.table(table(datos$TrafficType, datos$Revenue), margin = 1) %>% round(digits = 2)

table(datos$TrafficType, datos$Revenue)

#MSpecial Day
ggplot(data = datos, aes(x = SpecialDay, y = ..count.., fill = Revenue)) +
  geom_bar() +
  scale_fill_manual(values = c("gray50", "orangered2")) +
  labs(title = "special Day") +
  theme_bw() +
  theme(legend.position = "bottom")

#tabla de frecuencias

# Tabla de frecuencias 
prop.table(table(datos$SpecialDay, datos$Revenue), margin = 1) %>% round(digits = 2)

table(datos$SpecialDay, datos$Revenue)

#distribucion de frecuencias para variables continuas
plot_histogram(datos)

# Estadísticos de ingresos en funcion de variables continuas
datos %>% group_by(Revenue) %>%
          summarise(media = mean(Administrative),
                    mediana = median(Administrative),
                    min = min(Administrative),
                    max = max(Administrative))

datos %>% group_by(Revenue) %>%
          summarise(media = mean(Administrative_Duration),
                    mediana = median(Administrative_Duration),
                    min = min(Administrative_Duration),
                    max = max(Administrative_Duration))

datos %>% group_by(Revenue) %>%
          summarise(media = mean(Informational),
                    mediana = median(Informational),
                    min = min(Informational),
                    max = max(Informational))

datos %>% group_by(Revenue) %>%
          summarise(media = mean(Informational_Duration),
                    mediana = median(Informational_Duration),
                    min = min(Informational_Duration),
                    max = max(Informational_Duration))

datos %>% group_by(Revenue) %>%
          summarise(media = mean(ProductRelated),
                    mediana = median(ProductRelated),
                    min = min(ProductRelated),
                    max = max(ProductRelated))

datos %>% group_by(Revenue) %>%
          summarise(media = mean(ProductRelated_Duration),
                    mediana = median(ProductRelated_Duration),
                    min = min(ProductRelated_Duration),
                    max = max(ProductRelated_Duration))

datos %>% group_by(Revenue) %>%
          summarise(media = mean(BounceRates),
                    mediana = median(BounceRates),
                    min = min(BounceRates),
                    max = max(BounceRates))

datos %>% group_by(Revenue) %>%
          summarise(media = mean(ExitRates),
                    mediana = median(ExitRates),
                    min = min(ExitRates),
                    max = max(ExitRates))

datos %>% group_by(Revenue) %>%
          summarise(media = mean(PageValues),
                    mediana = median(PageValues),
                    min = min(PageValues),
                    max = max(PageValues))

#vemos el reparto de la variable ingresos

CrossTable(datos$Revenue,prop.chisq = FALSE, prop.c = FALSE, prop.r = TRUE)

correl <- cor(datos[,1:9])
correl

#graficamente
ggcorr(datos[,1:9],method = c("pairwise", "pearson"),low = "darkred", mid = "white", high = "steelblue")

ggcorr(datos[,1:9],geom="circle",method = c("pairwise", "pearson"),low = "darkred", mid = "white", high = "darkgreen")

library(corrplot)
corrplot(correl,method= 'number')

#Variables muy correlacionadas; 
set.seed(7)
cutoff <- 0.85
correlations <- cor(datos[,1:9])
highlyCorrelated <- findCorrelation(correlations, cutoff=cutoff)
for (value in highlyCorrelated) {
  #mostramos las variables con alta correlacion
    print(names(datos)[value])
}

# Creación de un nuevo fichero sin las variables con correlaciones altss
datos_sin_altas<- datos[,-highlyCorrelated]
dim(datos_sin_altas)

head(datos_sin_altas)

#varianza cero
varzero_datos <-datos%>% nearZeroVar(saveMetrics = TRUE)
varzero_datos

#Escalado y Centrado de Datos Para evitar la influencia de los valores altos en determinadas variables, ya que no están todas en el mismo rango, debemos reescalarlos y centrarlos en media 0.
valores_normalizar <- preProcess(datos_sin_altas, method = c("center", "scale"))

datos_normal <- predict(valores_normalizar, datos_sin_altas)

summary(datos_normal)

#datos normalizados sin altas correlaciones

datos_reducidos<-SMOTE(Revenue~.,data = datos_normal,perc.over = 100,perc.under=200)
table(datos_reducidos$Revenue)

#datos normalizados con altas correlaciones
#datos_reducidos2<-SMOTE(Revenue~.,data = datos_normal2,perc.over = 100,perc.under=200)
#table(datos_reducidos2$Revenue)

Resul_Modelo <- function( modelo ){

# Cálculos
  # Curvas ROC
  pred_prob_ent <- predict(modelo, entrenamiento, type="prob")
  pred_prob_val <- predict(modelo, validacion, type="prob")
  curvaROC_ent <- roc(entrenamiento$Revenue,pred_prob_ent[,"yes"])
  curvaROC_val <- roc(validacion$Revenue,pred_prob_val[,"yes"])
  # Predicciones del modelo
  pred_Y <- predict(modelo, validacion, type="raw")

# Resultados generales
  print(modelo$results)
  print(paste("Mejor modelo:"))
  print(modelo$bestTune)
  print(modelo$finalModel)
  print(paste(c("ROC del modelo con el fichero de validación:"), auc(curvaROC_val)))

# Gráfico de curvas ROC
  if (modelo$method == "treebag" | modelo$method == "xxx"){
    plot(curvaROC_val,col="red", main="Simulación con la curva ROC del modelo")
    legend("bottomright", legend = c("Validacion"), col = c("red"), lwd = 2)
  }else{
    plot(curvaROC_ent,col="blue", main="Simulación con la curva ROC del modelo")
    plot(curvaROC_val, col="red", add=TRUE)
    legend("bottomright", legend = c("Entrenamiento", "Validacion"), col = c("blue", "red"), lwd = 2)
  }

# Tabla de confusión e importancia de las variables
  print(confusionMatrix(modelo))
  print(CrossTable(pred_Y, validacion$Revenue, prop.chisq = TRUE, prop.c = TRUE, prop.r = TRUE))
  print(varImp(modelo))
}

CurvasROC <- function( modelos ){
  n_modelos = length(modelos)
  pred <- NULL
  nombresModelos <- NULL
  colores <- NULL
  
  pred[[1]] <- predict(modelos[1], validacion, type="prob")

  # Colores para cada modelo generados de forma aleatoria
  colores <- colours(sample(1:502, size = n_modelos))

  plot ( roc(validacion$Revenue,pred[[1]][[1]][,"yes"]), col = colores[1], main="Curvas ROC de todos los modelos" )

  for( j in 1:length(modelos))
  {
    nombresModelos[j] <- modelos[[j]]$method
  }
  
  legend("bottomright", legend = nombresModelos, col = colores, lwd = 2)
         
  for (i in 2:n_modelos){
    pred[[i]] <- predict(modelos[i], validacion, type="prob")
    plot ( roc(validacion$Revenue,pred[[i]][[1]][,"yes"]), col = colores[i], add=TRUE )
  }
}

Result <- function ( modelos ){
  n_modelos = length(modelos)
  comparativa <- matrix(0, n_modelos, 7)
  pred <- NULL

  for (i in 1:n_modelos){
    pred[[i]] <- predict(modelos[i], validacion, type="prob")
    comparativa[i,1] = modelos[[i]]$method

       comparativa[i,2] = modelos[[i]]$results[rownames(modelos[[i]]$bestTune), c("ROC")]
       comparativa[i,3] = modelos[[i]]$results[rownames(modelos[[i]]$bestTune), c("Sens")]
       comparativa[i,4] = modelos[[i]]$results[rownames(modelos[[i]]$bestTune), c("Spec")]
       comparativa[i,5] = modelos[[i]]$results[rownames(modelos[[i]]$bestTune), c("Accuracy")]
       comparativa[i,6] = modelos[[i]]$results[rownames(modelos[[i]]$bestTune), c("Kappa")]
    
    comparativa[i,7] = auc(roc(validacion$Revenue,pred[[i]][[1]][,"yes"]))
  }
  colnames(comparativa) <- c("Modelo", "ROC", "Sens", "Spec", "Accuracy", "Kappa", "ROC Validación")
  return(comparativa)
}

set.seed(107)

# Índice de partición
Indice_Particion <- createDataPartition(datos_reducidos$Revenue, p = 0.80, list = FALSE)

# Muestras de entrenamiento y test
entrenamiento <- datos_reducidos[ Indice_Particion, ]
validacion <- datos_reducidos[ -Indice_Particion, ]

#vemos el reparto de la variable dependiente en los distintos dataset de entrenamiento y validacion,
table(entrenamiento$Revenue)

table(validacion$Revenue)

fiveStats = function(...) c (twoClassSummary(...), defaultSummary(...))
control <- trainControl(method = "repeatedcv", 
                        #numero de muestras
                        number = 5,
                        repeats = 1, 
                        classProbs = TRUE, 
                        preProc = c("center", "scale"),
                        summaryFunction = fiveStats,
                        returnResamp = "final",
                        allowParallel = TRUE)
metrica <- "ROC"

control_oob <- trainControl(method = "oob", #especifico para algoritmos de Baggin, no hace particionado de datos, no incluimos CV
                            verboseIter=FALSE,
                            classProbs = TRUE) #igualmente queremos info de probabilidades

#clusterCPU <- makePSOCKcluster(detectCores()-1)
#registerDoParallel(clusterCPU)

#durante el entrenamiento la variable entrena tomará valor 1; una vez finalizado, tomará valor 0 para leer los modelos almacenados.
#entrena <- 1
entrena <- 0

if (entrena == 1) {
# Perceptrón multicapa
#en una primera aproximacion tomamos los valores por defecto de caret.
#mlpGrid<- NULL
mlpGrid <- expand.grid(size = c(3,4))

mlpx <- train(Revenue ~ ., 
             data = entrenamiento, 
             method = "mlp", 
             metric = metrica,
             #preProc = c("center", "scale"),
             trControl = control,
             tuneGrid = mlpGrid)


saveRDS(mlpx, file ="mlpex5.rds")


#Lectura del ajuste
mlpx<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/mlpex5.rds")
plot(mlpx)
mlpx$results
stopCluster(clusterCPU)
}

#clusterCPU <- makePSOCKcluster(detectCores()-1)
#registerDoParallel(clusterCPU)

if (entrena == 1){
  mlpx$bestTune[1,1]
  
}
#REalizamos nuestro modelo con el mejor ajuste, en nuestro caso ha sido con 3 neuronas.


if (entrena == 1){
  
size = mlpx$bestTune[1,1]
  mlpGrid <-  expand.grid(size = size)
  mlpf <- train(Revenue ~ ., 
             data = entrenamiento, 
             method = "mlp", 
             metric = metrica,
             #preProc = c("center", "scale"),
             trControl = control,
             tuneGrid = mlpGrid)


saveRDS(mlpf, file ="mlpex5fm.rds")
mlpfm<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/mlpex5fm.rds")
}

#Lectura del modelo final
if (entrena == 0){

mlpf<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/mlpex5fm.rds")
}

#mostramos los resultados del modelo
mlpf_dataf <-as.data.frame(mlpf$results)
mlpf$results

#Validacion
prediccion_prob_mlp <- predict(mlpf,validacion,type = "prob")


prediccion_mlp <- predict(mlpf,validacion)
prediccion_mlp <- factor(prediccion_mlp)


# Matriz de confusión

confusion_mlp <- confusionMatrix(data = prediccion_mlp, reference = validacion$Revenue)

confusion_mlp

#curva ROC
roc_mlp <- roc(validacion$Revenue,prediccion_prob_mlp[[1]])

plot(roc_mlp,legacy.axes=TRUE,print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("red", "blue"), max.auc.polygon=TRUE,
     auc.polygon.col="hotpink")

#probamos con distintos valores de coste y sigma.

if (entrena == 1){
  #svm

#svm1
#svmGrid <-  expand.grid(sigma = c(0.001, 0.005,0.01,0.05), C = c(1,20,50,100))
#svm2 
#svmGrid <-  expand.grid(sigma = c(0.001), C = c(50,100))
#svm3 0.0025 0.0050 0.0075 0.0100 0.0125 0.0150 0.0175 0.0200 0.0225 0.0250
#svmGrid <-  expand.grid(sigma = c(0.0025,0.01,0.02), C = c(0.1,0.5,1))
svmGrid <-  expand.grid(sigma = c(0.0100, 0.0125,0.015), C = c(1))
#svmGrid <- NULL
#svmGrid <-  expand.grid(sigma = 1:10/400,
#                       C = 1:10/10)
  svmx <- train(Revenue ~ ., 
               data = entrenamiento, 
               method= "svmRadial", 
               metric = metrica, 
               #preProc = c("center", "scale"), 
               trControl = control, 
               tuneGrid = svmGrid) 
  saveRDS(svmx, file ="svmex54.rds")
svmx<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/svmex54.rds")

plot(svmx)
svmx
svmx$results
}

#svm1<-svm
#svm3<-svm
#El mejor ajuste obtenido, 
if (entrena == 1)  {
sigma = svmx$bestTune[1,1]
c = svmx$bestTune[1,2]
svmGrid <-  expand.grid(sigma = sigma, C =c)
svmf <- train(Revenue ~ ., 
               data = entrenamiento, 
               method= "svmRadial", 
               metric = metrica, 
               #preProc = c("center", "scale"), 
               trControl = control, 
               tuneGrid = svmGrid) 
  saveRDS(svmf, file ="svmex5f.rds")
svmf<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/svmex5f.rds")
svmf
}

if (entrena == 0){
svmf<- readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/svmex5f.rds")
}

svmf$results

svmf_dataf <-as.data.frame(svmf$results)

#Validacion
prediccion_prob_svm <- predict(svmf,validacion,type = "prob")


prediccion_svm <- predict(svmf,validacion)
prediccion_svm <- factor(prediccion_svm)



# Matriz de confusión

confusion_svm <- confusionMatrix(data = prediccion_svm, reference = validacion$Revenue)

confusion_svm

#curva ROC
roc_svm <- roc(validacion$Revenue,prediccion_prob_svm[[1]])

plot(roc_svm,legacy.axes=TRUE,print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("red", "blue"), max.auc.polygon=TRUE,
     auc.polygon.col="hotpink")

# k - vecinos
if (entrena == 1){
#knnGrid <-  expand.grid(k = c(120,150))
#knnGrid <-  expand.grid(k = c(60,80,100,150))
knnGrid <-  expand.grid(k = c(10,15,30,60,80,100,150))
  #knnGrid <- NULL
knnx = train(Revenue ~ ., 
            data = entrenamiento, 
            method = "knn", 
            metric = metrica, 
            #preProc = c("center", "scale"), 
            trControl = control,
            tuneGrid = knnGrid) 

saveRDS(knnx, file ="knnex5.rds")
knnx<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/knnex5.rds")
knnx

plot(knnx)
knnx$results
}

if (entrena == 1) {
#Modelo con mejor resultado
k = knnx$bestTune[1,1]
knnGrid <- expand.grid(k = k)
knnf = train(Revenue ~ ., 
            data = entrenamiento, 
            method = "knn", 
            metric = metrica, 
            #preProc = c("center", "scale"), 
            trControl = control,
            tuneGrid = knnGrid) 

saveRDS(knnf, file ="knnex5f.rds")
knnf<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/knnex5f.rds")
knnf$results
}

if (entrena == 0){
#Lectura del modelo final
knnf<- readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/knnex5f.rds")
}

knnf$results

knnf_dataf <-as.data.frame(knnf$results)

#Validacion
prediccion_prob_knn <- predict(knnf,validacion,type = "prob")


prediccion_knn <- predict(knnf,validacion)
prediccion_knn <- factor(prediccion_knn)



# Matriz de confusión

confusion_knn <- confusionMatrix(data = prediccion_knn, reference = validacion$Revenue)

confusion_knn

#curva ROC
roc_knn <- roc(validacion$Revenue,prediccion_prob_knn[[1]])

plot(roc_knn,legacy.axes=TRUE,print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("red", "blue"), max.auc.polygon=TRUE,
     auc.polygon.col="hotpink")

if (entrena == 1){
#boostGrid <-  expand.grid(nIter = 1:10*50, method = c("Adaboost.M1"))
#boostx
#boostGrid <-  expand.grid(nIter = c(50,300), method = c("Adaboost.M1"))
boostGrid <-  expand.grid(nIter = c(350,500), method = c("Adaboost.M1"))
clusterCPU <- makePSOCKcluster(detectCores()-1)
registerDoParallel(clusterCPU)
boosty <- train(Revenue ~ ., data = entrenamiento, 
              method = "adaboost", 
              metric = metrica, 
              #preProc = c("center", "scale"), 
              trControl = control,
              tuneGrid = boostGrid)
stopCluster(clusterCPU)
boosty
plot(boosty)
saveRDS(boosty,file ="boostex5y.rds")
boosty<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/boostex5y.rds")
}

#aumento el limite de la memoria, el algoritmo me da muchos problemas, a parte de tiempo de computación, al intentar almacenarlo, me daba error de memoria, perdiendo los datos y muuucho tiempo. 
memory.limit(56000)

memory.size () ### Comprobando el tamaño de su memoria

memory.limit () ## Comprobación del límite establecido

if (entrena == 0){
boosty<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/boostex5y.rds")
#leo solo la prueba que mejores resultados me ha dado, puesto que esta lectura también colapsa en ocasiones el pc.
#boostx<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/boostex5.rds")



  
}

#De igual manera dejo asteriscados los plot y resultados
#plot(boosty)
#boosty$results
#boostx$results

#boosty$bestTune
#realizo el modelo con el bestune de la configuración boosty  = 500
if (entrena == 1){
#boostGrid <-  expand.grid(nIter = 1:10*50, method = c("Adaboost.M1"))
#boostGrid <-  expand.grid(nIter = c(50,300), method = c("Adaboost.M1"))
c = boosty$bestTune[1,1]
boostGrid <-  expand.grid(nIter = 500, method = c("Adaboost.M1"))
clusterCPU <- makePSOCKcluster(detectCores()-1)
registerDoParallel(clusterCPU)
boostf <- train(Revenue ~ ., data = entrenamiento, 
              method = "adaboost", 
              metric = metrica, 
              #preProc = c("center", "scale"), 
              trControl = control,
              tuneGrid = boostGrid)
saveRDS(boostf,file ="boostex5f.rds")

}


boostf<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/boostex5f.rds")

boostf$results

boostf_dataf <-as.data.frame(boostf$results)

#Validacion
prediccion_prob_boost <- predict(boostf,validacion,type = "prob")


prediccion_boost <- predict(boostf,validacion)
prediccion_boost<- factor(prediccion_boost)



# Matriz de confusión

confusion_boost <- confusionMatrix(data = prediccion_boost, reference = validacion$Revenue)

confusion_boost

#curva ROC
roc_boost <- roc(validacion$Revenue,prediccion_prob_boost[[1]])

plot(roc_boost,legacy.axes=TRUE,print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("red", "blue"), max.auc.polygon=TRUE,
     auc.polygon.col="hotpink")

if (entrena == 1){
#ajuste del modelo Random Forest
clusterCPU <- makePSOCKcluster(detectCores()-1)
registerDoParallel(clusterCPU)
set.seed(9)
#rfx
#tune_grid = NULL#le da una serie de valores y busca el propio caret los mejores posibles. el propio caret lo realiza. y sobre ese mejor valor, ya podemos probar nosotros para afinar mas 
#frx2
tune_grid = expand.grid(mtry = 4)
rfx2 <- train( Revenue~., entrenamiento,  
                    method = "rf",  #random forest
                    metric = "ROC", 
                    trControl = control,
                    tuneGrid = tune_grid)

stopCluster(clusterCPU)
rfx2


saveRDS(rfx2, file ="rfex52.rds")

#Lectura del ajuste
rfx2 <-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/rfex52.rds")

}

if (entrena == 0){
  rff <-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/rfex52.rds")
}

rff$results

rff_dataf<-as.data.frame(rff$results)

#Validacion
prediccion_prob_rf <- predict(rff,validacion,type = "prob")


prediccion_rf <- predict(rff,validacion)
prediccion_rf <- factor(prediccion_rf)



# Matriz de confusión

confusion_rf <- confusionMatrix(data = prediccion_rf, reference = validacion$Revenue)

confusion_rf

#curva ROC
roc_rf <- roc(validacion$Revenue,prediccion_prob_rf[[1]])

plot(roc_rf,legacy.axes=TRUE,print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("red", "blue"), max.auc.polygon=TRUE,
     auc.polygon.col="hotpink")

if (entrena == 1){
#Modelo Baggin
# Para reproducir siempre igual la parte aleatoria
set.seed(9)
#tune_grid = expand.grid #cuantas variables aleatorias selecciona para hacer el split, para implementar el baggin basico coge todas las variables.(3 variables independeintes)
tune_grid = NULL
modelo_bagging <- train( Revenue~., datos_normal, 
                         method = "rf",
                         metric = "Accuracy",
                         trControl = control_oob,
                         tuneGrid=tune_grid)

saveRDS(modelo_bagging, file ="bagging.rds")
bg <-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/bagging.rds")
bg$results
plot(bg)
}

if (entrena == 0){
  bgf <-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/bagging.rds")
bgf$results
}

# Regresión logística
if (entrena == 1){
glm <- train( Revenue ~ ., 
              data = entrenamiento, 
              method = "glm", metric = 
              metrica,
              preProc = c("center", "scale"), 
              trControl = control)
saveRDS(glm, file ="glmex5.rds")
readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/glmex5.rds")
}
if (entrena == 0){
  glmf<-readRDS(file="C:/Users/smans/Documents/sara/Master/Modulo 5/Examen/glmex5.rds")
}

glmf$results

glmf_datf <- as.data.frame(glmf$results)

#Validacion
prediccion_prob_glm <- predict(glmf,validacion,type = "prob")

prediccion_glm <- predict(glmf,validacion)

prediccion_glm <- factor(prediccion_glm)



# Matriz de confusión

confusion_glm <- confusionMatrix(data = prediccion_glm, reference = validacion$Revenue)

confusion_glm

#curva ROC
roc_glm <- roc(validacion$Revenue,prediccion_prob_glm[[1]])

plot(roc_glm,legacy.axes=TRUE,print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("red", "blue"), max.auc.polygon=TRUE,
     auc.polygon.col="hotpink")

Resul_Modelo(mlpf)

plot(varImp(mlpf))

Resul_Modelo(knnf)

plot(varImp(knnf))

Resul_Modelo(svmf)

plot(varImp(svmf))

Resul_Modelo(rff)

plot(varImp(rff))

Resul_Modelo(boostf)

plot(varImp(boostf))

modelos <- list(mlpf, knnf, svmf, rff,boostf)
Comparativa <- as.data.frame(Result (modelos))

print(Comparativa)

modelos <- list(RF = rff, KNN = knnf, MLP = mlpf, SVM = svmf, boost = boostf)
resultados <- resamples(modelos)
resultados

summary(resultados)

dotplot(resultados)

diferencias <- diff(resultados)
summary(diferencias)

bwplot(diferencias,layout=c(3,3))

names(diferencias)

resultadose <- data.frame(
  modelo1=c(mlpf$modelInfo$label,
           knnf$modelInfo$label,
           svmf$modelInfo$label,
           boostf$modelInfo$label,
           rff$modelInfo$label),
          
  #AUCS de cada modelo
  ROC=round(c(mlpf_dataf$ROC,
               knnf_dataf$ROC,
               svmf_dataf$ROC,
              boostf_dataf$ROC,
              rff_dataf$ROC),digits = 3),
               

  #datos de precision de cada modelo, lo obtenemos de la matriz confusion
  Accuracy=round(c(mlpf_dataf$Accuracy,
                    knnf_dataf$Accuracy,
                    svmf_dataf$Accuracy,
                   boostf_dataf$Accuracy,
                    rff_dataf$Accuracy),digits=3),

    #datos del indice KAppa de cada modelo, lo obtenemos de la matriz confusion
  Kappa=round(c(mlpf_dataf$Kappa,
                    knnf_dataf$Kappa,
                    svmf_dataf$Kappa,
                    boostf_dataf$Kappa,
                    rff_dataf$Kappa),digits=3))

  
resultadose

#Visualizamos los resultados
resultadose %>%
  mutate(
    modelo1 = modelo1,
    ROC = color_tile("white", "orange")(ROC),#rango de colosres de blanco a naranja, cuanto mas naranja mejor
    Accuracy = color_tile("white", "lightblue")(Accuracy),
    Kappa = color_tile("white", "lightgreen")(Kappa)
  ) %>%
  select(modelo1, everything()) %>%
  kable(escape = F) %>%
  kable_styling("hover", full_width = F) %>%
  add_header_above(c(" ", "Entrenamiento" = 3))

resultados <- data.frame(
  modelo=c(mlpf$modelInfo$label,
           knnf$modelInfo$label,
           svmf$modelInfo$label,
           boostf$modelInfo$label,
           rff$modelInfo$label),
          
  #AUCS de cada modelo
  AUC=round(c(auc(roc_mlp),
               auc(roc_knn),
              auc(roc_svm),
              auc(roc_boost),
              auc(roc_rf)),digits = 3),
               

  #datos de precision de cada modelo, lo obtenemos de la matriz confusion
  Accuracy=round(c(confusion_mlp[["overall"]][["Accuracy"]],
                    confusion_knn[["overall"]][["Accuracy"]],
                    confusion_svm[["overall"]][["Accuracy"]],
                   confusion_boost[["overall"]][["Accuracy"]],
                    confusion_rf[["overall"]][["Accuracy"]]),digits=3),

    #datos del indice KAppa de cada modelo, lo obtenemos de la matriz confusion
  Kappa=round(c(confusion_mlp[["overall"]][["Kappa"]],
                    confusion_knn[["overall"]][["Kappa"]],
                    confusion_svm[["overall"]][["Kappa"]],
                   confusion_boost[["overall"]][["Kappa"]],
                    confusion_rf[["overall"]][["Kappa"]]),digits=3),

  
  AciertosClaseSI=round(c(confusion_mlp[["byClass"]][["Pos Pred Value"]],
                          confusion_knn[["byClass"]][["Pos Pred Value"]],
                           confusion_svm[["byClass"]][["Pos Pred Value"]],
                           confusion_boost[["byClass"]][["Pos Pred Value"]],
                          confusion_rf[["byClass"]][["Pos Pred Value"]]),digits=3),
  
  AciertosClaseNO=round(c(confusion_mlp[["byClass"]][["Neg Pred Value"]],
                          confusion_knn[["byClass"]][["Neg Pred Value"]],
                          confusion_svm[["byClass"]][["Neg Pred Value"]],
                          confusion_boost[["byClass"]][["Neg Pred Value"]],
                          confusion_rf[["byClass"]][["Neg Pred Value"]]),digits=3))


#Visualizamos los resultados
resultados %>%
  mutate(
    modelo = modelo,
    AUC = color_tile("white", "orange")(AUC),#rango de colosres de blanco a naranja, cuanto mas naranja mejor
    Accuracy = color_tile("white", "lightblue")(Accuracy),
    Kappa = color_tile("white", "lightgreen")(Kappa),
    AciertosClaseSI = color_tile("white", "hotpink")(AciertosClaseSI),
    AciertosClaseNO = color_tile("white", "hotpink")(AciertosClaseNO)
  ) %>%
  select(modelo, everything()) %>%
  kable(escape = F) %>%
  kable_styling("hover", full_width = F) %>%
  add_header_above(c(" ", "Test" = 5))