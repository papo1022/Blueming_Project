package com.kh.blueming.common.template;

//XSS 공격을 방지하기 위한 규칙
public class XssDefencePolicy {
	public String defence(String originText) {
		String changeText = originText;
		changeText = changeText.replace("<", "&lt;");
		changeText = changeText.replace(">", "&gt;");
		changeText = changeText.replace("\"", "&quot;");
		changeText = changeText.replace("'", "&apos;");
		return changeText;
	}
}
