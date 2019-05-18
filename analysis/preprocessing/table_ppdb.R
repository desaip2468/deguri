library(ggplot2)
library(gridExtra)
library(grid)

headers <- c("M0001","M0002","M0003","M0004","M0005","M0006","M0007","M0008","M0009","M0010","M0011","M0012","M0013","M0014","M0015","M0016")
colClasses <- c(map(headers, function(x){ "numeric" }), "numeric")
csv <- read.csv("output.csv", colClasses = colClasses)

# Percentage
for (header in headers) {
  csv[header] <- sprintf("%1.2f%%", as.numeric(unlist(csv[header] / csv$total * 100)))
}

# Drop uninteresting columns
csv <- csv[headers]
csv <- t(csv)[,1:6]
colnames(csv) <- c("10", "20", "30", "40", "50", "60")
rownames(csv) <- c(
  "온라인/모바일 지불) 지난 1개월 간 신용카드 이용 여부 ",
  "온라인/모바일 지불) 지난 1개월 간 11페이 이용 여부 ",
  "온라인/모바일 지불) 지난 1개월 간 페이코 이용 여부 ",
  "온라인/모바일 지불) 지난 1개월 간 네이버페이 이용 여부 ",
  "온라인/모바일 지불) 지난 1개월 간 카카오페이 이용 여부 ",
  "온라인/모바일 지불) 지난 1개월 간 삼성페이 이용 여부 ",
  "온라인/모바일 지불) 지난 1개월 간 티머니 이용 여부 ",
  "온라인/모바일 지불) 지난 1개월 간 핸드폰결제 이용 여부 ",
  "오프라인 지불) 지난 1개월 간 현금 이용 여부",
  "오프라인 지불) 지난 1개월 간 신용카드 일반결제 이용 여부",
  "오프라인 지불) 지난 1개월 간 신용카드 모바일결제 이용 여부",
  "오프라인 지불) 지난 1개월 간 체크카드 이용 여부",
  "오프라인 지불) 지난 1개월 간 티머니 이용 여부",
  "오프라인 지불) 지난 1개월 간 삼성페이 이용 여부",
  "오프라인 지불) 지난 1개월 간 페이코 이용 여부",
  "오프라인 지불) 지난 1개월 간 카카오페이 이용 여부"
)

grid.table(csv)
