public func onMainDo<T>(_ firstMainBlock: @escaping () -> Void,
                        onBackgroundDo backgroundBlock: @escaping () -> T,
                        thenOnMainDo mainBlock: @escaping (T) -> Void) {
  DispatchQueue.main.async {
    firstMainBlock()
    DispatchQueue.global(qos: .background).async {
      let result = backgroundBlock()
      DispatchQueue.main.async {
        mainBlock(result)
      }
    }
  }
}
