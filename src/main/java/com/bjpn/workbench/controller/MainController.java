package com.bjpn.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/workbench/main")
public class MainController {
    @RequestMapping("/toIndex.action")
    public String toIndex() {
        return "workbench/index";
    }
    @RequestMapping("/toMainIndex.action")
    public String toMainIndex() {
        return "workbench/main/index";
    }
}