package com.bjpn.util;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.GlobalConfig;
import com.baomidou.mybatisplus.generator.config.PackageConfig;
import com.baomidou.mybatisplus.generator.config.StrategyConfig;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;

public class AutoTest {
    public static void main(String[] args) {
        // 1、全局配置
        GlobalConfig globalConfig = new GlobalConfig();//构建全局配置对象
        // String projectPath = System.getProperty("user.dir");// 获取当前用户的目录
        globalConfig.setActiveRecord(false)//不开启ActiveRecord方式
                //生成路径(一般都是生成在此项目的src/main/java下面)
                .setOutputDir("D:\\crm\\src\\main\\java")
                //.setAuthor("yxm")// 设置作者名字
                .setOpen(false)// 是否打开资源管理器
                .setFileOverride(true)// 是否覆盖原来生成的  第二次的会把第一次的覆盖掉
                .setIdType(IdType.AUTO)// 主键策略
                .setBaseResultMap(true)// 生成resultMap
                .setBaseColumnList(true)// XML中生成基础列
                .setServiceName("%sService");// 生成的service接口名字首字母是否为I，这样设置就没有I
        // IMapper  IService

        // 2、数据源配置  它可以识别pom文件中的jar包
        DataSourceConfig dataSourceConfig = new DataSourceConfig();// 创建数据源配置
        dataSourceConfig.setDbType(DbType.MYSQL)//数据库类型
                .setDriverName("com.mysql.cj.jdbc.Driver")
                .setUrl("jdbc:mysql://localhost:3306/crm?serverTimezone=UTC")
                .setUsername("root")
                .setPassword("873639952");

        // 3、包配置
        PackageConfig packageConfig = new PackageConfig();
        packageConfig.setParent("com.bjpn.workbench")//设置包名的parent
                .setMapper("mapper")
                .setService("service")
                .setController("controller")
                .setEntity("bean")
                .setXml("mapper");//设置xml文件的目录

        // 4、策略配置  数据库表的配置
        StrategyConfig strategyConfig = new StrategyConfig();
        strategyConfig
                .setCapitalMode(true)// 开启全局大写命名
                .setInclude("tbl_customer_remark")// 设置要映射的表
                .setTablePrefix("tbl_")//设置生成对应实体类 去掉该前缀  User
                .setNaming(NamingStrategy.underline_to_camel)// 下划线到驼峰的命名方式
                .setColumnNaming(NamingStrategy.underline_to_camel)// 下划线到驼峰的命名方式
                .setEntityLombokModel(false)// 是否使用lombok
                .setRestControllerStyle(false)// 是否开启rest风格
                .setControllerMappingHyphenStyle(false);// localhost:8080/hello_a_2

        // 5、自定义配置（配置输出xml文件到resources下）
       /* InjectionConfig cfg = new InjectionConfig() {
            @Override
            public void initMap() {
                // to do nothing
            }
        };
        List<FileOutConfig> focList = new ArrayList<>();
        String templatePath = "/templates/mapper.xml.vm";
        // 自定义配置会被优先输出
        focList.add(new FileOutConfig(templatePath) {
            @Override
            public String outputFile(TableInfo tableInfo) {
                // 自定义输出文件名 ， 如果你 Entity 设置了前后缀、此处注意 xml 的名称会跟着发生变化！！
                return  "D:\\testidea\\spring-mybatisplus\\src\\main\\resources\\mapper\\"
                        + tableInfo.getEntityName() + "Mapper" + StringPool.DOT_XML;
            }
        });
        cfg.setFileOutConfigList(focList);*/

        // 6、整合配置
        AutoGenerator autoGenerator = new AutoGenerator();// 构建代码生自动成器对象
        autoGenerator
                .setGlobalConfig(globalConfig)// 将全局配置放到代码生成器对象中
                .setDataSource(dataSourceConfig)// 将数据源配置放到代码生成器对象中
                .setPackageInfo(packageConfig)// 将包配置放到代码生成器对象中
                .setStrategy(strategyConfig)// 将策略配置放到代码生成器对象中
                //.setCfg(cfg)// 将自定义配置放到代码生成器对象中
                .execute();// 执行！
    }

}
