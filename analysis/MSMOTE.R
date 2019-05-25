# https://github.com/wolverine28/Imbalance_classification/blob/c61041a0cd63692e5fee293757bc9487f0326412/Experiment/code/MSMOTE.R

MSMOTE <- function(data, target.column, k1, k2, n) {
  
  library(FNN)
  # target.column : column of the input data containing class labels
  # k1 : number of nearest neighbors to assign data type
  # k2 : number of nearest neighbors to perform SMOTE 
  # n : amount of SMOTE n%
  y <- data[ ,target.column]
  if (is.character(y) == TRUE) {
    y <- as.factor(y)
    y <- as.numeric(y)
  } else if (is.factor(y) == TRUE) {
    y <- as.numeric(y)
  }
  tmp <- table(y)
  n.total <- sum(tmp)
  
  
  if (length(tmp) != 2) {
    stop("Error : not for the binary classification")
  }
  y.mn <- which.min(tmp)
  n.mn <- tmp[y.mn]
  n.mj <- n.total - n.mn
  y.mn <- as.numeric(names(y.mn))
  ind.mn <- which(y == y.mn) #ind.mn : index of data in minority class
  ind.mj <- 1:n.total
  ind.mj <- ind.mj[-ind.mn]  #ind.mj : index of data in majority class

  data <- data[,-target.column]
  data <- as.matrix(data)
  
  nn <- get.knnx(data = data,
                 query = data[ind.mn,],
                 k = k1,
                 algorithm = "kd_tree")$nn.index
  r <- apply(X = nn,
             MARGIN = 1,
             FUN = function(x) sum(x %in% ind.mj))
  ind.security <- which(r == 0)
  ind.noise <- which(r == k1)
  
  ind.border <- ind.mn[-c(ind.security, ind.noise)]
  ind.security <- ind.mn[ind.security]
  ind.noise <- ind.mn[ind.noise]
  n.security <- length(ind.security)
  n.border <- length(ind.border)
  
  nn.security <- get.knnx(data = data[ind.mn,],
                         query = data[ind.security,],
                         k = k2,
                      algorithm = "kd_tree")$nn.index
  nn.border <- get.knnx(data = data[ind.mn,],
                       query = data[ind.border,],
                       k = k2,
                       algorithm = "kd_tree")$nn.index
 
  new.security <- matrix(data = NA, nrow = 0, ncol = ncol(data))
  new.border <- matrix(data = NA, nrow = 0, ncol = ncol(data))
  while(nrow(new.security)!=(n/100*n.security)){
    for (i in 1:n.security) {
      s <- sample(c(1:k2), size = 1)
      ref <- ind.mn[nn.security[i,s]]
      new <- data[ind.security[i],] + runif(1)*(data[ref,]-data[ind.security[i],])
      new.security <- rbind(new.security, new)
    }
  }
  while(nrow(new.border)!=(n/100*n.border)){
    for (i in 1:n.border) {
      ref <- ind.mn[nn.border[i,2]]
      new <- data[ind.border[i],] + runif(1)*(data[ref,]-data[ind.border[i],])
      new.border <- rbind(new.border, new)
    }
  }
  
  remain <- (n/100*n.mn)%%(n.security+n.border)
  
  if(remain>0) {
    for (i in 1:remain) {
      s <- sample(c(1:2), size = 1)
       if(s==1) {
          p <- sample(c(1:n.security), size = 1)
          q <- sample(c(1:k2), size = 1)
          ref <- ind.mn[nn.security[p,q]]
          new <- data[ind.security[p],] + runif(1)*(data[ref,]-data[ind.security[p],])
          new.security <- rbind(new.security, new)
          }
      else if(s==2) {
          p <- sample(c(1:n.border), size = 1)
          ref <- ind.mn[nn.border[p,2]]
          new <- data[ind.border[p],] + runif(1)*(data[ref,]-data[ind.border[p],])
          new.border <- rbind(new.border, new)
          }
      }
  }
  
  status <- list()
  status[[1]] <- ind.security
  status[[2]] <- ind.border
  status[[3]] <- ind.noise
  names(status) <- c("Security","Border","Noise")
  result <- list(new.security, new.border, status)
  names(result) <- c("new.sample.security", "new.sample.border", "status")
 
  return(result)
  
}
