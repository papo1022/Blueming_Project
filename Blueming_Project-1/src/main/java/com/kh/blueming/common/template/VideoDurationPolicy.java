package com.kh.blueming.common.template;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.TimeUnit;

public class VideoDurationPolicy {

    private static final String FFMPEG_DIR_NAME = "ffmpeg-8.1.1-essentials_build";
    private static final String FFPROBE_EXECUTABLE = isWindows() ? "ffprobe.exe" : "ffprobe";

    private static final Set<String> VIDEO_EXT = Set.of(
            "mp4", "mov", "m4v", "mkv", "avi", "wmv", "webm", "mpeg", "mpg"
    );

    private VideoDurationPolicy() {
    }

    /**
     * 영상 파일의 재생 길이(초)를 ffprobe 로 추출한다.
     * 영상이 아닌 파일은 null, 추출 실패는 0 을 반환한다.
     */
    public static Integer extractVideoDurationSeconds(File file, String originalName, String contentType) {
        if (!isVideoFile(originalName, contentType)) {
            return null;
        }
        if (file == null || !file.exists()) {
            return 0;
        }
        return runFfprobe(file, originalName);
    }

    private static Integer runFfprobe(File file, String originalName) {
        Process process = null;
        try {
            String ffprobeCommand = resolveFfprobeCommand();
            ProcessBuilder pb = new ProcessBuilder(
                    ffprobeCommand,
                    "-v", "error",
                    "-show_entries", "format=duration",
                    "-of", "default=noprint_wrappers=1:nokey=1",
                    file.getAbsolutePath()
            );
            pb.redirectErrorStream(true);
            process = pb.start();

            String line;
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                line = br.readLine();
            }

            boolean finished = process.waitFor(15, TimeUnit.SECONDS);
            if (!finished || process.exitValue() != 0) {
                System.err.println("[VideoDurationPolicy] ffprobe timed out or failed for: " + originalName
                        + " (command=" + ffprobeCommand + ")");
                return 0;
            }

            if (line == null || line.isBlank()) {
                System.err.println("[VideoDurationPolicy] ffprobe returned empty output for: " + originalName);
                return 0;
            }

            double seconds = Double.parseDouble(line.trim());
            return seconds > 0 ? (int) Math.ceil(seconds) : 0;

        } catch (NumberFormatException e) {
            System.err.println("[VideoDurationPolicy] ffprobe output parse failed for: " + originalName);
            return 0;
        } catch (Exception e) {
            System.err.println("[VideoDurationPolicy] ffprobe execution failed: " + e.getMessage());
            return 0;
        } finally {
            if (process != null) {
                process.destroyForcibly();
            }
        }
    }

    private static String resolveFfprobeCommand() {
        String configuredPath = firstNonBlank(
                System.getProperty("blueming.ffprobe.path"),
                System.getenv("FFPROBE_PATH")
        );
        if (isExecutable(configuredPath)) {
            return configuredPath;
        }

        String ffmpegHome = System.getenv("FFMPEG_HOME");
        if (ffmpegHome != null && !ffmpegHome.isBlank()) {
            Path fromFfmpegHome = Paths.get(ffmpegHome, "bin", FFPROBE_EXECUTABLE);
            if (isExecutable(fromFfmpegHome.toString())) {
                return fromFfmpegHome.toString();
            }
        }

        Path userDir = Paths.get(System.getProperty("user.dir", ".")).normalize();
        Path[] candidates = {
                userDir.resolve(FFMPEG_DIR_NAME).resolve("bin").resolve(FFPROBE_EXECUTABLE),
                userDir.getParent() == null ? null : userDir.getParent().resolve(FFMPEG_DIR_NAME).resolve("bin").resolve(FFPROBE_EXECUTABLE)
        };

        for (Path candidate : candidates) {
            if (candidate != null && isExecutable(candidate.toString())) {
                return candidate.toString();
            }
        }

        // Fall back to PATH lookup.
        return FFPROBE_EXECUTABLE;
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return null;
    }

    private static boolean isExecutable(String path) {
        if (path == null || path.isBlank()) {
            return false;
        }
        File file = new File(path);
        return file.exists() && file.isFile();
    }

    private static boolean isWindows() {
        return System.getProperty("os.name", "").toLowerCase(Locale.ROOT).contains("win");
    }

    private static boolean isVideoFile(String originalName, String contentType) {
        if (contentType != null && contentType.toLowerCase(Locale.ROOT).startsWith("video/")) {
            return true;
        }
        return isVideoExtension(originalName);
    }

    private static boolean isVideoExtension(String originalName) {
        if (originalName == null || originalName.isBlank()) {
            return false;
        }
        int dotIndex = originalName.lastIndexOf('.');
        if (dotIndex < 0 || dotIndex == originalName.length() - 1) {
            return false;
        }
        String ext = originalName.substring(dotIndex + 1).toLowerCase(Locale.ROOT);
        return VIDEO_EXT.contains(ext);
    }

    public static String extractExtension(String originalName, String fallbackName) {
        String baseName = (originalName == null || originalName.isBlank()) ? fallbackName : originalName;
        if (baseName == null || baseName.isBlank()) {
            return "file";
        }
        int dotIndex = baseName.lastIndexOf('.');
        if (dotIndex < 0 || dotIndex == baseName.length() - 1) {
            return "file";
        }
        String ext = baseName.substring(dotIndex + 1).toLowerCase(Locale.ROOT);
        return ext.length() > 10 ? ext.substring(0, 10) : ext;
    }
}
