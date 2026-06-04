package com.kh.blueming.chapter.model.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@ToString
public class ChapterProgress {
    private int progressId;
    private int enrollmentId;
    private int chapterId;
    private int watchedSeconds;
    private int lastPositionSeconds;
    private double chapCompRate;
    private String isCompleted;
}
