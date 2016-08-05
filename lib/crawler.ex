defmodule Magnetissimo.Crawler do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send(self(), :work, [])
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.info "Initiating crawler run."

    Magnetissimo.Parsers.Demonoid.root_urls
    |> Enum.each(fn url -> 
      IO.puts "Queued: Demonoid root_urls"
      Exq.enqueue(Exq, "demonoid", "Magnetissimo.DownloadWorker", [url, "demonoid", "root_url"])
    end)

    Magnetissimo.Parsers.Isohunt.root_urls
    |> Enum.each(fn url -> 
      IO.puts "Queued: Isohunt root_urls"
      Exq.enqueue(Exq, "isohunt", "Magnetissimo.DownloadWorker", [url, "isohunt", "root_url"])
    end)

    Magnetissimo.Parsers.Limetorrents.root_urls
    |> Enum.each(fn url -> 
      IO.puts "Queued: Limetorrents root_urls"
      Exq.enqueue(Exq, "limetorrents", "Magnetissimo.DownloadWorker", [url, "limetorrents", "root_url"])
    end)

    Magnetissimo.Parsers.TorrentDownloads.root_urls
    |> Enum.each(fn url -> 
      IO.puts "Queued: TorrentDownloads root_urls"
      Exq.enqueue(Exq, "torrentdownloads", "Magnetissimo.DownloadWorker", [url, "torrentdownloads", "root_url"])
    end)

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 3_600_000) # 1 hour
  end
end