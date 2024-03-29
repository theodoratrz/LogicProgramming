# Summary

Στις αυτοκινητοβιομηχανίες, τα αυτοκίνητα κατασκευάζονται σε μία γραμμή συναρμολόγησης (assembly line). Σ’ ένα δεδομένο χρονικό διάστημα, π.χ. μία ημέρα, πρέπει να 
κατασκευασθεί ένας συγκεκριμένος αριθμός αυτοκινήτων από κάποιο μοντέλο που παράγει η εταιρεία, τα οποία δεν είναι κατ’ ανάγκη απολύτως όμοια στον εξοπλισμό τους. 
Δύο αυτοκίνητα που απαιτούν τις ίδιες ακριβώς επιλογές λέμε ότι ανήκουν στην ίδια σύνθεση (configuration). Για κάθε πιθανή επιλογή στον εξοπλισμό του μοντέλου, 
υπάρχει μία ομάδα εργασίας που δουλεύει σε κάποια περιοχή της γραμμής συναρμολόγησης. Όμως, για να μπορεί η κάθε ομάδα εργασίας να φέρει σε πέρας το έργο της, πρέπει, 
όσον αφορά την επιλογή με την οποία ασχολείται, να μην υπάρχουν ποτέ σε κάθε M συνεχόμενα αυτοκίνητα στη γραμμή συναρμολόγησης περισσότερα από K που να απαιτούν την
επιλογή. Τα M και K είναι συγκεκριμένα για κάθε δυνατή επιλογή. Η απαίτηση αυτή ονομάζεται περιορισμός χωρητικότητας (capacity constraint). Το πρόβλημα της δρομολόγησης 
παραγωγής αυτοκινήτων (car sequencing) συνίσταται στον καθορισμό της σειράς με την οποία πρέπει να παραχθούν N αυτοκίνητα σε μία γραμμή συναρμολόγησης, έχοντας επίσης 
δεδομένες τις δυνατές επιλογές, τους περιορισμούς χωρητικότητάς τους και τα πλήθη των αυτοκινήτων που αντιστοιχούν σε επιθυμητές συνθέσεις (συνδυασμοί επιλογών).
Ορίζουμε ένα κατηγόρημα carseq/1, το οποίο όταν καλείται σαν carseq(S), να επιστρέφει στο S τη σειρά με την οποία πρέπει να τοποθετηθούν αυτοκίνητα των διαφόρων  
πιθανών συνθέσεων σε μία γραμμή συναρμολόγησης. Το S που επιστρέφεται πρέπει να είναι μία λίστα, κάθε στοιχείο της οποίας είναι ο αύξων αριθμός της σύνθεσης στην οποία 
ανήκει το αντίστοιχο αυτοκίνητο στη γραμμή συναρμολόγησης. Τα δεδομένα του προβλήματος δίνονται μέσω των κατηγορημάτων classes/1 και options/1. 

Ένα παράδειγμα δεδομένων είναι το εξής:

`classes([1,1,2,2,2,2]).
options([2/1/[1,0,0,0,1,1], 3/2/[0,0,1,1,0,1], 3/1/[1,0,0,0,1,0], 5/2/[1,1,0,1,0,0], 5/1/[0,0,1,0,0,0]]).`

Τα παραπάνω δεδομένα περιγράφουν την εξής κατάσταση: Υπάρχουν 6 πιθανές συνθέσεις, όσα είναι τα στοιχεία της λίστας που είναι όρισμα στο κατηγόρημα classes/1.
Κάθε επιλογή ορίζεται μέσω μίας τριάδας Μ/Κ/Ο, όπου τα M και K εκφράζουν τον περιορισμό χωρητικότητας της επιλογής (το πολύ K αυτοκίνητα σε κάθε M συνεχόμενα στη 
γραμμή συναρμολόγησης πρέπει να απαιτούν την επιλογή) και το O είναι μία λίστα από 1 και 0, μήκους όσο το πλήθος των πιθανών συνθέσεων, που εκφράζει το αν η εν λόγω 
επιλογή περιλαμβάνεται στην αντίστοιχη σύνθεση (τιμή 1) ή όχι (τιμή 0).

Τα αποτελέσματα εκτέλεσης για τα δεδομένα αυτά είναι:

`?- carseq(S).`

`S = [1, 2, 6, 3, 5, 4, 4, 5, 3, 6]`

`S = [1, 3, 6, 2, 5, 4, 3, 5, 4, 6]`

`S = [1, 3, 6, 2, 6, 4, 5, 3, 4, 5]`

`S = [5, 4, 3, 5, 4, 6, 2, 6, 3, 1]`

`S = [6, 3, 5, 4, 4, 5, 3, 6, 2, 1]`

`S = [6, 4, 5, 3, 4, 5, 2, 6, 3, 1]`

`no`

Το πρώτο από τα αποτελέσματα ([1, 2, 6, 3, 5, 4, 4, 5, 3, 6]) εκφράζει ότι η αλυσίδα συναρμολόγησης πρέπει να αποτελείται κατά σειρά από ένα αυτοκίνητο της 1ης σύνθεσης, 
ένα της 2ης, ένα της 6ης, ένα της 3ης, κοκ. Παρατηρούμε ότι για τα δεδομένα αυτά, υπάρχουν έξι δυνατές λύσεις.
