# Group A - Exercise 1

# Summary

Μία ακολουθία από σύμβολα μπορεί να κωδικοποιηθεί σύμφωνα με τη λογική του τρέχοντος μήκους (run length encoding) με τον εξής τρόπο. Κάθε μέγιστη υποακολουθία από το ίδιο σύμβολο S μήκους N (> 1) κωδικοποιείται σαν ένα ζευγάρι (S,N). Υποακολουθίες μήκους 1 δεν κωδικοποιούνται, αλλά απλά παραμένει στο αποτέλεσμα το σύμβολο S. Για παράδειγμα, η ακολουθία “a, a, a, b, b, c, d, d, d, d, e” κωδικοποιείται σαν “(a,3), (b,2), c, (d,4), e”. Ορίζουμε ένα κατηγόρημα Prolog decode_rl/2, το οποίο όταν καλείται με πρώτο όρισμα μία λίστα που παριστάνει μία κωδικοποιημένη ακολουθία συμβόλων, σύμφωνα με τα παραπάνω, να την αποκωδικοποιεί και να επιστρέφει στο δεύτερο όρισμα το αποτέλεσμα. Τα σύμβολα μπορεί να είναι όροι Prolog, όχι όμως μεταβλητές. Μπορούν να είναι όμως δομές που περιέχουν μεταβλητές. 

Κάποια παραδείγματα εκτέλεσης:

`?- decode_rl([(a,3),(b,2),c,(d,4),e], L). 
L = [a,a,a,b,b,c,d,d,d,d,e]`

`?- decode_rl([(f(5,a),7)], L).
L = [f(5,a),f(5,a),f(5,a),f(5,a),f(5,a),f(5,a),f(5,a)]`

`?- decode_rl([g(X),(h(Y),3),k(Z),(m(W),4),n(U)], L).
L = [g(X),h(Y),h(Y),h(Y),k(Z),m(W),m(W),m(W),m(W),n(U)]`

Στη συνέχεια, υλοποιηούμε σε Prolog και την κωδικοποίηση τρέχοντος μήκους,
ορίζοντας ένα κατηγόρημα encode_rl/2, το οποίο να επιτελεί την αντίστροφη
λειτουργία από αυτήν του decode_rl/2. Δηλαδή να παίρνει σαν πρώτο όρισμα μία
λίστα συμβόλων (όρων Prolog πλην μεταβλητών) και να επιστρέφει στο δεύτερο
όρισμα την κωδικοποιημένη εκδοχή της. 

Κάποια παραδείγματα εκτέλεσης:

`?- encode_rl([a,a,a,b,b,c,d,d,d,d,e], L).
L = [(a,3),(b,2),c,(d,4),e]`

`?- encode_rl([f(5,a),f(5,a),f(5,a),f(5,a),f(5,a),f(5,a),f(5,a)], L).
L = [(f(5,a),7)]`

`?- encode_rl([g(X),h(Y),h(Y),h(Y),k(Z),m(W),m(W),m(W),m(W),n(U)], L).
L = [g(X),(h(Y),3),k(Z),(m(W),4),n(U)]`
