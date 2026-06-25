pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property int totalSeconds: 0
  property string totalText: "0h 0m"
  property var dailyData: []
  property real maxDailySeconds: 0

  function formatDuration(seconds) {
    const h = Math.floor(seconds / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    if (h > 0) return h + "h " + m + "m";
    return m + "m";
  }

  function parseAndUpdate(raw) {
    const lines = raw.split('\n');
    let sessions = [];
    let currentStart = null;

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();
      if (line.startsWith('start ')) {
        currentStart = parseInt(line.substring(6));
      } else if (line.startsWith('end ') && currentStart !== null) {
        const end = parseInt(line.substring(4));
        if (!isNaN(currentStart) && !isNaN(end)) {
          sessions.push({ start: currentStart, end: end });
        }
        currentStart = null;
      } else if (line.startsWith('end ')) {
        currentStart = null;
      }
    }

    let total = 0;
    let daily = {};

    for (let s = 0; s < sessions.length; s++) {
      const session = sessions[s];
      const duration = (session.end - session.start) / 1000;
      if (duration > 0 && duration < 86400) {
        total += duration;
        const date = new Date(session.start).toISOString().split('T')[0];
        daily[date] = (daily[date] || 0) + duration;
      }
    }

    root.totalSeconds = Math.round(total);
    root.totalText = root.formatDuration(total);

    const dates = Object.keys(daily);
    let dailyArr = [];
    let maxSec = 0;
    for (let d = 0; d < dates.length; d++) {
      const key = dates[d];
      const sec = Math.round(daily[key]);
      dailyArr.push({ date: key, seconds: sec, text: root.formatDuration(sec) });
      if (sec > maxSec) maxSec = sec;
    }
    dailyArr.sort(function (a, b) {
      if (a.date < b.date) return 1;
      if (a.date > b.date) return -1;
      return 0;
    });

    root.dailyData = dailyArr;
    root.maxDailySeconds = maxSec;
  }

  Process {
    id: readProc
    command: ["cat", "/home/kyee/33/obsidian/store/code-time.md"]
    running: false

    stdout: StdioCollector {
      onStreamFinished: root.parseAndUpdate(this.text)
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: readProc.running = true
  }

  Component.onCompleted: readProc.running = true
}
