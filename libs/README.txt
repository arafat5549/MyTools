存放一些MVN需要再本地安装的包
#IKAnalyzer2012_u6.jar 中文分词器
mvn install:install-file -Dfile=libs/IKAnalyzer2012_u6.jar -DgroupId=org.wltea.analyzer -DartifactId=IKAnalyzer -Dversion=2012_u6 -Dpackaging=jar

#ojdbc14-10.2.0.4.0.jar  Oracle数据库连接库(因为版权关系无法在中央仓库安装)
mvn install:install-file -Dfile=libs/ojdbc14-10.2.0.4.0.jar -DgroupId=com.oracle -DartifactId=ojdbc14 -Dversion=10.2.0.4.0 -Dpackaging=jar
