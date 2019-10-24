{
  "targets": [
    {
      "target_name": "dnd-manager",
      "sources": [
        "src/dnd-manager.cc"
      ],
      "include_dirs": [
        "<!(node -e \"require('nan')\")",
        "chrome_headers",
      ],
      "conditions": [
        ['OS=="mac"', {
          "sources": [
            "src/dnd-manager-mac.mm",
          ],
          "link_settings": {
            "libraries": [
              "-framework", "AppKit"
            ]
          }
        }]
      ]
    }
  ]
}
