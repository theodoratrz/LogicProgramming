# Summary

Το πρόβλημα της μέγιστης κλίκας (maximum clique problem) σε γράφο συνίσταται στην εύρεση ενός συνόλου κόμβων του γράφου που ανά δύο να συνδέονται μεταξύ τους και το πλήθος τους να είναι το μέγιστο δυνατό. Για παράδειγμα, μπορούμε να βρούμε ένα μέγιστο σύνολο μελών του Facebook που όλοι να είναι φίλοι μεταξύ τους ανά δύο;

Για την αντιμετώπιση του προβλήματος αυτού, χρησιμοποιούμε γράφους που κατασκευάζονται μέσω του κατηγορήματος create_graph(N, D, G), όπως αυτό ορίζεται στο αρχείο create_graph.pl. Κατά την κλήση του κατηγορήματος δίνεται το πλήθος N των κόμβων του γράφου και η πυκνότητά του D (σαν ποσοστό των ακμών που υπάρχουν στον γράφο σε σχέση με όλες τις δυνατές ακμές) και επιστρέφεται ο γράφος G σαν μία λίστα από ακμές της μορφής N1-N2, όπου N1 και N2 είναι οι δύο κόμβοι της ακμής (οι κόμβοι του γράφου
παριστάνονται σαν ακέραιοι από το 1 έως το N). 

Ένα παράδειγμα εκτέλεσης του κατηγορήματος αυτού είναι το εξής:

`?- seed(1), create_graph(9, 30, G).
G = [1 - 5, 2 - 4, 2 - 6, 3 - 4, 3 - 6, 3 - 9, 4 - 7, 5 - 7, 6 - 7, 6 - 8, 6 - 9]`

Για την άσκηση αυτή, ορίζουμε κατηγόρημα maxclq/4, το οποίο όταν καλείται σαν maxclq(N, D, Clique, Size), αφού δημιουργήσει ένα γράφο N κόμβων και πυκνότητας D, καλώντας το κατηγόρημα create_graph/3, να βρίσκει μία μέγιστη κλίκα του γράφου, επιστρέφοντας στο Clique τη λίστα με τους κόμβους της κλίκας και στο Size το μέγεθός της. 

Κάποια παραδείγματα εκτέλεσης είναι τα εξής:

`?- seed(1), maxclq(8, 80, Clique, Size).
Clique = [2, 4, 5, 6, 7]
Size = 5`

`?- seed(2022), maxclq(15, 60, Clique, Size).
Clique = [1, 3, 5, 10, 14, 15]
Size = 6`
