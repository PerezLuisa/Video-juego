const titles = {
  overview: "Panel principal",
  patient: "Modulo Paciente",
  caregiver: "Modulo Cuidador",
  doctor: "Modulo Medico",
  games: "Minijuegos",
  progress: "Avances del proyecto",
};

const navItems = document.querySelectorAll(".nav-item");
const views = document.querySelectorAll(".view");
const viewTitle = document.querySelector("#view-title");

function showView(id) {
  views.forEach((view) => view.classList.toggle("active", view.id === id));
  navItems.forEach((item) => item.classList.toggle("active", item.dataset.view === id));
  viewTitle.textContent = titles[id] || "Alzheimer Early Stage";
}

navItems.forEach((item) => {
  item.addEventListener("click", () => showView(item.dataset.view));
});

document.querySelectorAll("[data-jump]").forEach((button) => {
  button.addEventListener("click", () => showView(button.dataset.jump));
});

const board = document.querySelector("#memory-board");
const triesText = document.querySelector("#tries");
const matchesText = document.querySelector("#matches");
const resetButton = document.querySelector("#reset-game");
const icons = ["Casa", "Flor", "Sol", "Pan", "Taza", "Libro"];
let firstCard = null;
let lockBoard = false;
let tries = 0;
let matches = 0;

function shuffle(items) {
  return [...items].sort(() => Math.random() - 0.5);
}

function renderGame() {
  board.innerHTML = "";
  firstCard = null;
  lockBoard = false;
  tries = 0;
  matches = 0;
  triesText.textContent = tries;
  matchesText.textContent = matches;

  shuffle([...icons, ...icons]).forEach((value) => {
    const card = document.createElement("button");
    card.className = "card";
    card.type = "button";
    card.dataset.value = value;
    card.dataset.label = value;
    card.textContent = "?";
    card.setAttribute("aria-label", `Carta oculta ${value}`);
    card.addEventListener("click", () => flipCard(card));
    board.appendChild(card);
  });
}

function flipCard(card) {
  if (lockBoard || card.classList.contains("flipped") || card.classList.contains("matched")) {
    return;
  }

  card.classList.add("flipped");
  card.textContent = card.dataset.label;

  if (!firstCard) {
    firstCard = card;
    return;
  }

  tries += 1;
  triesText.textContent = tries;

  if (firstCard.dataset.value === card.dataset.value) {
    firstCard.classList.add("matched");
    card.classList.add("matched");
    firstCard = null;
    matches += 1;
    matchesText.textContent = matches;
    return;
  }

  lockBoard = true;
  const previousCard = firstCard;
  setTimeout(() => {
    previousCard.classList.remove("flipped");
    card.classList.remove("flipped");
    previousCard.textContent = "?";
    card.textContent = "?";
    firstCard = null;
    lockBoard = false;
  }, 850);
}

resetButton.addEventListener("click", renderGame);
renderGame();
