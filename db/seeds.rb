# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Suppression des données existantes pour éviter les doublons
require "open-uri"
require "json"

# Suppression des anciens records
puts "Suppression des anciens records..."
Bookmark.destroy_all
Review.destroy_all
List.destroy_all
Movie.destroy_all

# Récupération des films via l'API TMDB
puts "Récupération des films depuis l'API..."
url = "https://tmdb.lewagon.com/movie/top_rated"
movies_serialized = URI.open(url).read
movies = JSON.parse(movies_serialized)["results"]

movies.first(20).each do |movie| # On limite à 20 films pour éviter un seed trop long
  Movie.create!(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: "https://image.tmdb.org/t/p/original#{movie["poster_path"]}",
    rating: movie["vote_average"]
  )
end
puts "Films récupérés et ajoutés !"

# Création des listes
puts "Création des listes..."
lists = [
  { name: "Action" },
  { name: "Drama" },
  { name: "Science-Fiction" },
  { name: "Girl Power" },
  { name: "All Time Favorites" }
]

lists.each do |list|
  List.create!(list)
end
puts "Listes créées !"

# Ajout automatique de bookmarks
puts "Ajout de signets..."
lists = List.all
movies = Movie.all

lists.each do |list|
  sample_movies = movies.sample(2) # Choisir 2 films au hasard par liste
  sample_movies.each do |movie|
    Bookmark.create!(list: list, movie: movie, comment: "Super film à voir !")
  end
end
puts "Signets ajoutés !"

# Ajout de commentaires sur les listes
puts "Ajout d'avis sur les listes..."
reviews_content = [
  "J'adore cette sélection, les films sont incroyables !",
  "Une excellente liste, parfaite pour une soirée cinéma.",
  "Super choix de films, j'aurais peut-être ajouté quelques classiques.",
  "Une sélection intéressante, mais certains films ne sont pas à mon goût.",
  "Parfait pour les amateurs du genre !",
  "Vraiment bien pensé, chaque film est une pépite.",
  "J'ai découvert des films que je ne connaissais pas, merci !"
]

lists.each do |list|
  rand(1..3).times do
    Review.create!(
      list: list,
      content: reviews_content.sample,
      rating: rand(1..5)
    )
  end
end
puts "Avis ajoutés !"

puts "Seed terminée avec succès ! 🎬"
