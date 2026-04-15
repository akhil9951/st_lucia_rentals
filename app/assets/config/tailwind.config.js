module.exports = {
    content: [
      './public/*.html',
      './app/helpers/**/*.rb',
      './app/javascript/**/*.js',
      './app/views/**/*.{erb,haml,html,slim}' // Ensure this line exists!
    ],
    theme: {
      extend: {},
    },
    plugins: [],
  }