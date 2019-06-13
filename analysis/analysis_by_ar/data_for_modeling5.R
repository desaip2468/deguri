# data for regression

library(tidyverse)


data<-read.csv("C:/Users/user/Desktop/2019-1/DATA/EMBRAIN/payments_ppdb_app_category_code_aggregated.csv")

attach(data)

#category code aggregate

category_code<-data.frame(panel_id,age, category_code_1_count,category_code_2_count, category_code_3_count, category_code_4_count, 
                          category_code_5_count, category_code_6_count, category_code_7_count, category_code_8_count,
                          category_code_9_count, category_code_10_count, category_code_11_count, category_code_12_count, 
                          category_code_13_count, category_code_14_count, category_code_15_count, category_code_16_count)


#company code aggregate

dplyr::select
bk<-data%>% dplyr::select(starts_with("company_code_BK"))
bksum<-rowSums(bk)
cd<-data%>% dplyr::select(starts_with("company_code_CD"))
cdsum<-rowSums(cd)
cu<-data%>% dplyr::select(starts_with("company_code_CU"))
cusum<-rowSums(cu)
se<-data%>% dplyr::select(starts_with("company_code_SE"))
sesum<-rowSums(se)
sb<-data%>% dplyr::select(starts_with("company_code_SB"))
sbsum<-rowSums(sb)
sp<-data%>% dplyr::select(starts_with("company_code_SP"))
spsum<-rowSums(sp)
pa<-data%>% dplyr::select(starts_with("company_code_PA"))

company_code_aggregated<-data.frame(pa, bksum,cdsum,cusum,sesum,sbsum,spsum)

#category code + company code

company_category<-data.frame(category_code,company_code_aggregated)

#앱사용시간 변수 추가
appuseage<-data[ , 1185:1381]



#approval price

approval_price<-data%>%dplyr::select(starts_with("price_sum_by_by_approval_type"))

data2<-data.frame(company_category,appuseage,approval_price)

write.csv(data2, "C:/Users/user/Desktop/2019-1/DATA/EMBRAIN/data_for_modeling5.csv")

