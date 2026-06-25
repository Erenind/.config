pragma Singleton

import Quickshell
import QtQuick

// SVG path data from Material Design Icons (Apache 2.0)
Singleton {
  readonly property string cpu:
    "M6 4h12v1h-1v1h1v1h-1v1h1v1h-1v1h1v1h-1v1h1v1h-12v-1h1v-1h-1v-1h1v-1h-1v-1h1v-1h-1v-1h1v-1h-1v-1h1v-1zm1 1v2h2v-2h-2zm4 0v2h2v-2h-2zm4 0v2h2v-2h-2zm-8 4v2h2v-2h-2zm4 0v2h2v-2h-2zm4 0v2h2v-2h-2zm-8 4v2h2v-2h-2zm4 0v2h2v-2h-2zm4 0v2h2v-2h-2zm-8 4v2h2v-2h-2zm4 0v2h2v-2h-2zm4 0v2h2v-2h-2z"

  readonly property string memory:
    "M17 17V7H7v10h10m4-10v2h-2V7h2m-2 6v2h2v-2h-2m-2 6v2h2v-2h-2m-6 2v2h2v-2h-2m-6-2v2h2v-2H5m-2-6v2h2v-2H3m2-4V7H3v2h2m6-4V3H9v2h2m4 0V3h-2v2h2m4 0V3h-2v2h2z"

  readonly property string volume:
    "M14 3.23v2.06c2.89.86 5 3.54 5 6.71s-2.11 5.85-5 6.71v2.06c4.01-.91 7-4.49 7-8.77s-2.99-7.86-7-8.77M16.5 12c0-1.77-1-3.29-2.5-4.03v8.05c1.5-.73 2.5-2.25 2.5-4.02M3 9v6h4l5 5V4L7 9H3z"

  readonly property string volumeMuted:
    "M3 9v6h4l5 5V4L7 9H3zm13.59 3l-2.09-2.09L15.5 8.91 18 11.41l2.5-2.5 1.5 1.5-2.5 2.5 2.5 2.5-1.5 1.5-2.5-2.5-2.5 2.5-1.5-1.5 2.09-2.09z"

  readonly property string wifi:
    "M1 9l2 2c4.97-4.97 13.03-4.97 18 0l2-2C16.93 2.93 7.08 2.93 1 9zm8 8l3 3 3-3c-1.65-1.66-4.34-1.66-6 0zm-4-4l2 2c2.76-2.76 7.24-2.76 10 0l2-2C15.14 9.14 8.87 9.14 5 13z"

  readonly property string wired:
    "M4 1h6v4H9v2H5V5H4V1zm10 0h6v4h-1v2h-4V5h-1V1zM7 7h2v4H7V7zm8 0h2v4h-2V7zM5 12h14v4h-1v2h-4v-2H9v2H5v-2H4v-4zm3 6h2v4H8v-4zm6 0h2v4h-2v-4z"

  readonly property string battery:
    "M15.67 4H14V2h-4v2H8.33C7.6 4 7 4.6 7 5.33v15.33C7 21.4 7.6 22 8.33 22h7.33c.74 0 1.34-.6 1.34-1.33V5.33C17 4.6 16.4 4 15.67 4zM15 20H9V6h6v14z"

  readonly property string batteryCharging:
    "M15.67 4H14V2h-4v2H8.33C7.6 4 7 4.6 7 5.33v15.33C7 21.4 7.6 22 8.33 22h7.33c.74 0 1.34-.6 1.34-1.33V5.33C17 4.6 16.4 4 15.67 4zM11 20v-5.5H9l4-7v5.5h2l-4 7z"

  readonly property string power:
    "M13 2.05v2.02c3.95.5 7 3.85 7 7.93 0 4.41-3.59 8-8 8s-8-3.59-8-8c0-4.08 3.05-7.43 7-7.93V2.05C5.05 2.58 2 6.13 2 10c0 5.52 4.48 10 10 10s10-4.48 10-10c0-3.87-3.05-7.42-7-7.95zM11 2h2v12h-2V2z"

  readonly property string clock:
    "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67V7z"

  readonly property string launch:
    "M3 3h4v4H3V3zm7 0h4v4h-4V3zm7 0h4v4h-4V3zM3 10h4v4H3v-4zm7 0h4v4h-4v-4zm7 0h4v4h-4v-4zM3 17h4v4H3v-4zm7 0h4v4h-4v-4zm7 0h4v4h-4v-4z"

  readonly property string disconnected:
    "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"

  readonly property string batteryFull:
    "M15.67 4H14V2h-4v2H8.33C7.6 4 7 4.6 7 5.33v15.33C7 21.4 7.6 22 8.33 22h7.33c.74 0 1.34-.6 1.34-1.33V5.33C17 4.6 16.4 4 15.67 4zM11 16V9l-2 1.5v2L11 16z"
}
