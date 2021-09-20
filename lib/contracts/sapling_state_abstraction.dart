class SaplingStateAbstraction {
  BigInt? id;
  SaplingStateAbstraction(BigInt? id) {
    this.id = id;
  }

  getId() {
    return this.id.toString();
  }
}
