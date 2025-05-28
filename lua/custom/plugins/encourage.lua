return {
  dir = 'C:\\Users\\blake\\AppData\\Local\\nvim\\encourage.nvim',
  config = function()
    require('encourage').setup {
      messages = {
        'かわいい ✨    ',
        '萌える 🔥   ',
        'ツヨイ 💪   ',
        'バカ 🤤   ',
        'キラ 🌟    ',
        '頑張って 🎉  ',
        '何 ❓     ',
        '愛している ❤️',
        '死んでる 😵  ',
        '失敗 😩    ',
        '素晴らしい 🌈  ',
        '悲しい 😭    ',
      },
      timeout = 2500,
    }
  end,
}
