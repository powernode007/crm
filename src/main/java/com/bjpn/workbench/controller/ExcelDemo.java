package com.bjpn.workbench.controller;

import com.bjpn.workbench.bean.Userinfo;
import com.bjpn.workbench.service.UserinfoService;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

@Controller
@RequestMapping("/excel")
public class ExcelDemo {
    @Autowired
    UserinfoService userinfoService;

    @RequestMapping("/excelDownDemo.action")
    @ResponseBody
    public void excelDownDemo(HttpServletResponse response) throws IOException {
        //下载一个带有固定格式和数据的excel
        //生成excel的数据
        //1、创建了一个excel对象  给这个对象 提供页  行 列
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("第一页");
        HSSFRow row = sheet.createRow(0);

        //5、给列赋值
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("用户编号");
        cell = row.createCell(1);
        cell.setCellValue("用户姓名");
        cell = row.createCell(2);
        cell.setCellValue("用户电话");
        //用循环 给以下行赋值==>10行3列
        for (int i = 1; i <= 10; i++) {
            HSSFRow row1 = sheet.createRow(i);
            for (int j = 0; j <= 2; j++) {
                HSSFCell cell1 = row1.createCell(j);
                HSSFCellStyle style = wb.createCellStyle();
                style.setAlignment(HorizontalAlignment.CENTER);
                cell1.setCellStyle(style);
                if (j == 0) {
                    cell1.setCellValue(1000 + i);
                } else if (j == 1) {
                    cell1.setCellValue("大郎" + i);
                } else if (j == 2) {
                    cell1.setCellValue("1383838" + i);
                }
            }
        }
        //设置表中数据 居中
        String fileName = URLEncoder.encode("用户信息", "UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".xls");
        //wb就是一个10行3列的excel数据
        //把这个数据赋值到指定位置  下载
        //wb对象有write方法  把自己的数据 按照格式 写入到输出流中
        ServletOutputStream outputStream = response.getOutputStream();
        wb.write(outputStream);
        outputStream.flush();
        wb.close();
    }

    @RequestMapping("/excelFileUploadDemo.action")
    public String excelFileUploadDemo(String uname, MultipartFile upFile, HttpServletRequest request) throws IOException {
// upFile.transferTo(path);
        //如果是excel 我们要excel表中的数据 找excel格式上传
       /* String path =request.getServletContext().getRealPath("/fileupload");
        upFile.transferTo(new File(path+"/"+upFile.getOriginalFilename()));
        System.out.println("成功");
        //先上传  在通过io流去读取
        InputStream in = new FileInputStream(path+"/"+upFile.getOriginalFilename());*/
        //1、通过io流 读取文件中的内容
        InputStream in = upFile.getInputStream();
        //2创建 poi的Workbook对象
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.getSheetAt(0);
        for (int i = 1; i < sheet.getLastRowNum(); i++) {
            HSSFRow row = sheet.getRow(i);
            Userinfo userinfo = new Userinfo();//行对应userinfo对象
            //读取列
            for (int j = 0; j < row.getLastCellNum(); j++) {
                HSSFCell cell = row.getCell(j);
                //取列中的信息
                String cellvalue = getCellValueByType(cell);
                if (j == 0) {

                } else if (j == 1) {
                    userinfo.setUsername(cellvalue);
                } else if (j == 2) {
                    userinfo.setUsercode(cellvalue);
                } else if (j == 3) {
                    userinfo.setUserpwd(cellvalue);
                }

            }
            boolean save = userinfoService.save(userinfo);
        }
        return "redirect:/success.jsp";
    }

    public String getCellValueByType(HSSFCell cell) {
        String result = "";
        switch (cell.getCellType()) {
            case NUMERIC:
                result = cell.getNumericCellValue() + "";
                break;
            case STRING:
                result = cell.getStringCellValue();
                break;
            case ERROR:
                result = cell.getErrorCellValue() + "";
                break;
            case BOOLEAN:
                result = cell.getBooleanCellValue() + "";
                break;
            case FORMULA:
                result = cell.getCellFormula() + "";
                break;
            case BLANK:
                result = "";
                break;
        }
        return result;
    }
}
