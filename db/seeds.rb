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
# Suppression des anciens records pour éviter les doublons
puts "Suppression des anciens records..."
Bookmark.destroy_all
Review.destroy_all
List.destroy_all
Movie.destroy_all

# Création des films (comme dans l'énoncé)
puts "Création des films..."
movies = [
  { title: "Wonder Woman 1984", overview: "Wonder Woman entre en conflit avec l'Union soviétique pendant la Guerre Froide.", poster_url: "https://image.tmdb.org/t/p/original/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg", rating: 6.9 },
  { title: "The Shawshank Redemption", overview: "Un banquier est condamné à tort pour un double meurtre.", poster_url: "https://image.tmdb.org/t/p/original/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", rating: 8.7 },
  { title: "Titanic", overview: "L'histoire du Titanic racontée par une survivante âgée de 101 ans.", poster_url: "https://image.tmdb.org/t/p/original/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg", rating: 7.9 },
  { title: "Ocean's Eight", overview: "Une équipe de voleuses prépare le casse du siècle.", poster_url: "https://image.tmdb.org/t/p/original/MvYpKlpFukTivnlBhizGbkAe3v.jpg", rating: 7.0 }
]

movies.each do |movie|
  Movie.create!(movie)
end
puts "Films créés !"

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

# Ajout automatique de quelques bookmarks pour tester
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

# Ajout de commentaires sur les listes (Reviews)
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
  rand(1..3).times do # Chaque liste reçoit entre 1 et 3 avis aléatoires
    Review.create!(
      list: list,
      content: reviews_content.sample,
      rating: rand(1..5) # Note aléatoire entre 1 et 5
    )
  end
end
puts "Avis ajoutés !"

puts "Seed terminée avec succès ! 🎬"
