package com.bjpn.workbench.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.bjpn.settings.bean.User;
import com.bjpn.settings.service.UserService;
import com.bjpn.util.MessageUtil;
import com.bjpn.util.ReturnObject;
import com.bjpn.workbench.bean.*;
import com.bjpn.workbench.service.ActivityService;
import com.bjpn.workbench.service.BeizhuService;
import com.bjpn.workbench.service.CustomerRemarkService;
import com.bjpn.workbench.service.CustomerService;
import com.github.pagehelper.PageInfo;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Autowired
    ActivityService activityService;
    @Autowired
    UserService userService;
    @Autowired
    BeizhuService beizhuService;
    @Autowired
    CustomerService customerService;
    @Autowired
    CustomerRemarkService customerRemarkService;
    @RequestMapping("/toIndex.action")
    public String toIndex() {
        return "workbench/activity/index";
    }


    @RequestMapping("/toAdd.action")
    @ResponseBody
    public ReturnObject toAdd(ReturnObject returnObject, HttpSession session, Activity activity) {
//??????????????????????????????
        //????????????
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String format = sdf.format(date);
//?????????  ?????????????????????
        User user = (User) session.getAttribute("user");
        String userId = user.getUserId() + "";
        //???????????????????????????????????????????????????
        activity.setCreateTime(format);
        activity.setCreateBy(userId);
        boolean save = activityService.save(activity);
        String name = activity.getActivityName();
        for (int i = 0; i < 50; i++) {
            activity.setActivityId(0);
            activity.setActivityName(name + i);
            activityService.save(activity);
        }
        if (save) {
            //??????
            returnObject.setMessageCode(MessageUtil.SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.SUCCESS_STR);
        } else {
            //??????
            returnObject.setMessageCode(MessageUtil.FAIL_CODE);
            returnObject.setMessageStr(MessageUtil.FAIL_STR);
        }

        return returnObject;
    }

    //???????????????????????????
    @RequestMapping("/findAllActivityByLikePage.action")
    @ResponseBody
    public LikeActivity findAllActivityByLikePage(@RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "5") Integer pageSize, LikeActivity likeActivity) {
        List<Activity> activity = activityService.findAllActivityByLikePage(pageNum, pageSize, likeActivity);
        PageInfo<Activity> pageInfo = new PageInfo<>(activity);
        likeActivity.setPageInfoLike(pageInfo);
        return likeActivity;
    }

    //???????????????,?????????????????????
    @RequestMapping("/exportActivityAll.action")
    public void exportActivityAll(HttpServletResponse response) throws UnsupportedEncodingException {
        try {//???????????????  ?????????????????????????????????
            List<Activity> activityList = activityService.exportActivityAll();
            //????????????????????? ??????poi  ????????????????????????
            //1?????????workbook??????,????????????,11???
            HSSFWorkbook wb = new HSSFWorkbook();
            HSSFSheet sheet = wb.createSheet("??????????????????");
            HSSFRow row = sheet.createRow(0);
            HSSFCell cell = row.createCell(0);
            cell.setCellValue("??????????????????");
            cell = row.createCell(1);
            cell.setCellValue("??????????????????");
            cell = row.createCell(2);
            cell.setCellValue("?????????????????????");
            cell = row.createCell(3);
            cell.setCellValue("????????????????????????");
            cell = row.createCell(4);
            cell.setCellValue("????????????????????????");
            cell = row.createCell(5);
            cell.setCellValue("??????????????????");
            cell = row.createCell(6);
            cell.setCellValue("??????????????????");
            cell = row.createCell(7);
            cell.setCellValue("????????????????????????");
            cell = row.createCell(8);
            cell.setCellValue("?????????????????????");
            cell = row.createCell(9);
            cell.setCellValue("????????????????????????");
            cell = row.createCell(10);
            cell.setCellValue("?????????????????????");
            //??????????????????  ??????????????????,
            for (int i = 1; i <= activityList.size(); i++) {
                HSSFRow row1 = sheet.createRow(i);
                //??????????????????????????????,activityList[0]??????????????????
                Activity activity = activityList.get(i - 1);
                for (int j = 0; j < 11; j++) {
                    HSSFCell cell1 = row1.createCell(j);
                    if (j == 0) {
                        //????????????excel????????????????????????id???????????????excel??????id?????????
                        cell1.setCellValue(activity.getActivityId());
                    }
                    if (j == 1) {

                        cell1.setCellValue(activity.getActivityName());
                    }
                    if (j == 2) {

                        cell1.setCellValue(activity.getActivityOwner());
                    }
                    if (j == 3) {

                        cell1.setCellValue(activity.getActivityStartDate());
                    }
                    if (j == 4) {

                        cell1.setCellValue(activity.getActivityEndDate());
                    }
                    if (j == 5) {

                        cell1.setCellValue(activity.getActivityCost());
                    }
                    if (j == 6) {
                        cell1.setCellValue(activity.getActivityDescription());
                    }
                    if (j == 7) {

                        cell1.setCellValue(activity.getCreateTime());
                    }
                    if (j == 8) {
                        cell1.setCellValue(activity.getCreateBy());
                    }
                    if (j == 9) {

                        cell1.setCellValue(activity.getEditTime());
                    }
                    if (j == 10) {
                        cell1.setCellValue(activity.getEditBy());
                    }
                }
            }
            //?????? wb?????????
            //???????????????  ???????????????????????????
            String fileName = URLEncoder.encode("??????????????????", "UTF-8");
            Date date = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String format = sdf.format(date);
            //?????????????????????????????????????????????????????????????????????????????????????????????
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName + "-" + format + ".xls");
            //??????
            ServletOutputStream out = response.getOutputStream();
            wb.write(out);
            out.flush();
            wb.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    //    ??????????????????
    @RequestMapping("/exportActivityChecked.action")
    public void exportActivityChecked(HttpServletResponse response, String ids) {
        try { //ids  ?????????id?????????  ????????????????????????????????????  ??????????????????   5,4,1???
            String[] idsArr = ids.split(",");
            List<String> list = Arrays.asList(idsArr);
            List<Activity> activityList = activityService.listByIds(list);
            //????????????????????? ??????poi  ????????????????????????
            //1?????????workbook??????
            HSSFWorkbook wb = new HSSFWorkbook();
            //2????????????
            HSSFSheet sheet = wb.createSheet("??????????????????");
            //3????????????  ???????????????  ????????????
            HSSFRow row = sheet.createRow(0);
            //4????????????  11???
            HSSFCell cell = row.createCell(0);
            cell.setCellValue("??????????????????");
            cell = row.createCell(1);
            cell.setCellValue("??????????????????");
            cell = row.createCell(2);
            cell.setCellValue("?????????????????????");
            cell = row.createCell(3);
            cell.setCellValue("????????????????????????");
            cell = row.createCell(4);
            cell.setCellValue("????????????????????????");
            cell = row.createCell(5);
            cell.setCellValue("??????????????????");
            cell = row.createCell(6);
            cell.setCellValue("??????????????????");
            cell = row.createCell(7);
            cell.setCellValue("????????????????????????");
            cell = row.createCell(8);
            cell.setCellValue("?????????????????????");
            cell = row.createCell(9);
            cell.setCellValue("????????????????????????");
            cell = row.createCell(10);
            cell.setCellValue("?????????????????????");
            //??????????????????  ??????????????????
            for (int i = 1; i <= activityList.size(); i++) {
                HSSFRow row1 = sheet.createRow(i);
                //??????????????????????????????
                Activity activity = activityList.get(i - 1);
                for (int j = 0; j < 11; j++) {
                    HSSFCell cell1 = row1.createCell(j);
                    if (j == 0) {
                        cell1.setCellValue(activity.getActivityId());
                    } else if (j == 1) {
                        cell1.setCellValue(activity.getActivityName());
                    } else if (j == 2) {
                        cell1.setCellValue(activity.getActivityOwner());
                    } else if (j == 3) {
                        cell1.setCellValue(activity.getActivityStartDate());
                    } else if (j == 4) {
                        cell1.setCellValue(activity.getActivityEndDate());
                    } else if (j == 5) {
                        cell1.setCellValue(activity.getActivityCost());
                    } else if (j == 6) {
                        cell1.setCellValue(activity.getActivityDescription());
                    } else if (j == 7) {
                        cell1.setCellValue(activity.getCreateTime());
                    } else if (j == 8) {
                        cell1.setCellValue(activity.getCreateBy());
                    } else if (j == 9) {
                        cell1.setCellValue(activity.getEditTime());
                    } else if (j == 10) {
                        cell1.setCellValue(activity.getEditBy());
                    }
                }
            }
            //?????? wb?????????
            //???????????????  ???????????????????????????
            String fileName = URLEncoder.encode("????????????????????????", "utf-8");
            Date date = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String format = sdf.format(date);
            //?????????????????????????????????????????????????????????????????????????????????????????????
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName + "-" + format + ".xls");
            //??????
            OutputStream out = response.getOutputStream();
            wb.write(out);
            out.flush();
            wb.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    //????????????????????????
    @RequestMapping("/importActivityExcel.action")
    @ResponseBody
    public ReturnObject importActivityExcel(MultipartFile importFile, ReturnObject returnObject) throws Exception {
        //??????io??? ???excel???????????? ?????????workbook?????????
        InputStream in = importFile.getInputStream();
        HSSFWorkbook wb = new HSSFWorkbook(in);
        //??????poi????????????
        HSSFSheet sheet = wb.getSheetAt(0);
        //?????????????????????????????????
        ArrayList<Activity> list = new ArrayList<>();//?????????????????????????????????????????????????????????????????????service?????????
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            HSSFRow row = sheet.getRow(i);
            Activity activity = new Activity();
            for (int j = 0; j < row.getLastCellNum(); j++) {
                HSSFCell cell = row.getCell(j);
                String cellValue = getCellValueByType(cell);
                if (j == 0) {

                } else if (j == 1) {
                    activity.setActivityName(cellValue);
                } else if (j == 2) {
                    if (!"".equals(cellValue)) {
                        double v = Double.parseDouble(cellValue);
                        int activityOwner = (int) v;
                        activity.setActivityOwner(activityOwner);
                    }
                } else if (j == 3) {
                    activity.setActivityStartDate(cellValue);
                } else if (j == 4) {
                    activity.setActivityEndDate(cellValue);
                } else if (j == 5) {
                    activity.setActivityCost(cellValue);
                } else if (j == 6) {
                    activity.setActivityDescription(cellValue);
                } else if (j == 7) {
                    activity.setCreateTime(cellValue);
                } else if (j == 8) {
                    activity.setCreateBy(cellValue);
                } else if (j == 9) {
                    activity.setEditTime(cellValue);
                } else if (j == 10) {
                    activity.setEditBy(cellValue);
                }

            }
            list.add(activity);
        }

        boolean b = activityService.importExcelByList(list);
        if (b) {
            returnObject.setMessageCode(MessageUtil.SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.SUCCESS_STR);
        } else {
            returnObject.setMessageCode(MessageUtil.FAIL_CODE);
            returnObject.setMessageStr(MessageUtil.FAIL_STR);
        }
        return returnObject;
    }

    //cell??????????????? ??????
    public String getCellValueByType(HSSFCell cell) {
        String result = "";
        switch (cell.getCellType()) {
            case NUMERIC:
                result = cell.getNumericCellValue() + "";
                break;
            case BLANK:
                result = "";
                break;
            case FORMULA:
                result = cell.getCellFormula() + "";
                break;
            case BOOLEAN:
                result = cell.getBooleanCellValue() + "";
                break;
            case ERROR:
                result = cell.getErrorCellValue() + "";
            default:
                result = cell.getStringCellValue();
        }
        return result;
    }

    @RequestMapping("/selectById.action")
    @ResponseBody
    public Activity selectById(Integer activityId) {
        return activityService.getById(activityId);
    }

    @RequestMapping("/updateById.action")
    @ResponseBody
    public ReturnObject updateById(ReturnObject returnObject, Activity activity, HttpSession session) {
        //??????????????????????????????
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String nowTime = sdf.format(date);
        User user = (User) session.getAttribute("user");
        String editBy = user.getUserId() + "";
        activity.setEditBy(editBy);
        activity.setEditTime(nowTime);
        boolean b = activityService.updateById(activity);
        if (b) {
            returnObject.setMessageCode(MessageUtil.SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.SUCCESS_STR);
        } else {

            returnObject.setMessageCode(MessageUtil.FAIL_CODE);
            returnObject.setMessageStr(MessageUtil.FAIL_STR);
        }
        return returnObject;
    }

    @RequestMapping("/removeById.action")
    @ResponseBody
    public ReturnObject removeById(ReturnObject returnObject, String ids) {
        String[] idsArr = ids.split(",");
        List<String> list = Arrays.asList(idsArr);
        boolean b = activityService.removeByIds(list);
        if (b) {
            returnObject.setMessageCode(MessageUtil.SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.SUCCESS_STR);
        } else {
            returnObject.setMessageCode(MessageUtil.FAIL_CODE);
            returnObject.setMessageStr(MessageUtil.FAIL_STR);
        }
        return returnObject;
    }

    @RequestMapping("/tiaoZhuan.action")
    public String tiaoZhuan(HttpServletRequest request, String activityId) throws ServletException, IOException {
        Activity activity = activityService.getById(activityId);
        request.setAttribute("activity", activity);
        return "workbench/activity/detail";
    }

    @RequestMapping("/addBeizhu.action")
    @ResponseBody
    public ReturnObject addBeizhu(Beizhu beizhu, ReturnObject returnObject) throws ServletException, IOException {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String nowTime = sdf.format(date);
        beizhu.setBeizhuTime(nowTime);
        boolean b = beizhuService.save(beizhu);


        if (b) {
            returnObject.setMessageCode(MessageUtil.SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.SUCCESS_STR);
        } else {
            returnObject.setMessageCode(MessageUtil.FAIL_CODE);
            returnObject.setMessageStr(MessageUtil.FAIL_STR);
        }
        return returnObject;
    }

    @RequestMapping("/showPingLun.action")

    public String showPingLun(HttpServletRequest request, String activityId) throws IOException {
        Activity activity = activityService.getById(activityId);
        request.setAttribute("activity", activity);
        List<Beizhu> list = beizhuService.list();
        request.setAttribute("list", list);
        return "workbench/activity/detail";
    }

    @RequestMapping("/delPinglun.action")
    @ResponseBody
    public ReturnObject delPinglun(String beizhuId, ReturnObject returnObject) throws IOException {
        boolean b = beizhuService.removeById(beizhuId);
        if (b) {
            returnObject.setMessageCode(MessageUtil.SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.SUCCESS_STR);
        } else {
            returnObject.setMessageCode(MessageUtil.FAIL_CODE);
            returnObject.setMessageStr(MessageUtil.FAIL_STR);
        }
        return returnObject;

    }

    @RequestMapping("/updatePinglun.action")
    @ResponseBody
    public Beizhu updatePinglun(String beizhuId, HttpServletRequest request) throws IOException {
        Beizhu beizhu = beizhuService.getById(beizhuId);
        return beizhu;
    }
    @RequestMapping("/updatePinglun1.action")
    @ResponseBody
    public ReturnObject updatePinglun1(Beizhu beizhu, ReturnObject returnObject) throws IOException {

        boolean b = beizhuService.updateById(beizhu);
        if (b) {
            returnObject.setMessageCode(MessageUtil.SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.SUCCESS_STR);
        } else {
            returnObject.setMessageCode(MessageUtil.FAIL_CODE);
            returnObject.setMessageStr(MessageUtil.FAIL_STR);
        }
        return returnObject;

    }



}

