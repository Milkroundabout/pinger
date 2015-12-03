(import requests)
(import random)

(defn wget [u]
  "Fetch u as a url, ignore network errors"
  (try
   (requests.get u)
   (except [e requests.ConnectionError])))

(defn http-status [u]
  "Get the status code for fetching u as a URI, zero if no status"
  (let [[r (wget u)]]
       (if r (. r status-code) 0)))

(defn test-urls [l]
  "Get an iterable list of http statuses for a list of URIs l"
  (map http-status l))

(defn seq-of-char [ch]
  "return a function that infinitely iterates a list of ch"
  (repeatedly (fn [] ch)))

(defn line-format [urls statuses]
      "given a seqence of urls and a sequence of corresponding
statuses assemble a sequence of printable entries by adding field
separators and newlines"
      (interleave urls
                  (seq-of-char ":")
                  (map name statuses)
                  (seq-of-char "\n")))

(defn die-roll []
  "roll a dice using system rng"
  (random.randint 1 6))


(defmain [script prob &rest args]
         "given an integer <= 6 and a list of urls on stdin ping the
urls for content if a die roll is > than the integer"
         (if (> (die-roll) (int prob))
             (let [[statuses (test-urls args) ]]
                  (print
                   (.join "" (list (line-format args statuses)))))))
