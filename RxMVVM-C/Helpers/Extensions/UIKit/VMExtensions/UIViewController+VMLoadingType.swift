import UIKit
import RxSwift

extension ViewHolder where Self: UIViewController {

  func bindViewModelLoading(
    _ loading: Observable<VMLoadingType>,
    style: UIActivityIndicatorView.Style = .medium,
    backgroundColor: UIColor = .black,
    refreshControl: UIRefreshControl? = nil
  ) -> Disposable {
    loading.subscribe(onNext: { [unowned rootView] loadingType in
      let loading = loadingType.loading

      switch loadingType.type {
      case .blockingActivity:
        loading ? ProgressView.instance.show() : ProgressView.instance.hide()
      case .request:
        let isRefreshing = refreshControl?.isRefreshing ?? false
        guard !isRefreshing else {
          break
        }
        loading ? rootView.showActivity(style: style, backgroundColor: backgroundColor) : rootView.hideActivity()
      }

      if !loading {
        refreshControl?.endRefreshing() ?? (rootView as? UIScrollView)?.refreshControl?.endRefreshing()
      }
    })
  }
}
